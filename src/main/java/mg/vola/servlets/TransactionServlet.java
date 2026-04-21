package mg.vola.servlets;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mg.vola.dao.TransactionDAO;
import mg.vola.dao.FraisDAO;
import mg.vola.dao.ClientDAO;
import mg.vola.models.Envoi;
import mg.vola.models.Retrait;
import mg.vola.models.Client;
import java.io.FileInputStream;

@WebServlet("/TransactionServlet")
public class TransactionServlet extends HttpServlet {
    private TransactionDAO transDAO = new TransactionDAO();
    private FraisDAO fraisDAO = new FraisDAO();
    private ClientDAO clientDAO = new ClientDAO();

    // Configuration SMTP
    private final String MON_EMAIL = "ainasoa00@gmail.com";
    private final String MON_PASS = "hkdvyzdjrlyujbju";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            // --- LOGIQUE ENVOI ---
        	// --- LOGIQUE ENVOI CORRIGÉE ---
            if ("envoyer".equals(action)) {
                String numE = request.getParameter("numEnvoyeur");
                String numR = request.getParameter("numRecepteur");
                int montantBase = Integer.parseInt(request.getParameter("montant"));
                boolean payerFraisRetrait = request.getParameter("payerFraisRetrait") != null;
                String raison = request.getParameter("raison");

                // 1. Calcul des frais via le DAO
                int fraisEnv = fraisDAO.chercherFraisPourMontant(montantBase);
                int fraisRetraitAVerser = 0;
                
                if (payerFraisRetrait) {
                    // On calcule combien coûtera le retrait pour le récepteur sur ce montant
                    fraisRetraitAVerser = fraisDAO.chercherFraisRecPourMontant(montantBase);
                }

                // --- CALCUL DES FLUX FINANCIERS ---
                // L'envoyeur sort de sa poche : le montant + les frais d'envoi + les frais de retrait (si coché)
                int totalDebitEnvoyeur = montantBase + fraisEnv + fraisRetraitAVerser;
                
                // Le récepteur reçoit sur son solde : le montant + le bonus pour ses frais de retrait
                int montantFinalRecepteur = montantBase + fraisRetraitAVerser;

                Client envoyeur = clientDAO.trouverClient(numE);
                Client recepteur = clientDAO.trouverClient(numR);

                // Vérification de sécurité sur le solde
                if (envoyeur == null || envoyeur.getSolde() < totalDebitEnvoyeur) {
                    response.sendRedirect("transaction.jsp?msg=error_solde");
                    return;
                }

                // 2. Préparation de l'objet Envoi
                Envoi env = new Envoi();
                env.setIdEnv("ENV-" + System.currentTimeMillis() / 1000); 
                env.setNumEnvoyeur(numE);
                env.setNumRecepteur(numR);
                // On enregistre le montant gonflé dans l'historique car c'est ce qui arrive sur le compte du receveur
                env.setMontant(montantFinalRecepteur); 
                env.setDate(new Timestamp(System.currentTimeMillis()));
                env.setPayer_frais_retrait(payerFraisRetrait);
                env.setRaison(raison);

                // 3. Exécution en base de données
                // transDAO.effectuerEnvoi doit :
                // - Soustraire totalDebitEnvoyeur au solde de numE
                // - Ajouter montantFinalRecepteur au solde de numR
                transDAO.effectuerEnvoi(env, fraisEnv, fraisRetraitAVerser);

                // --- NOTIFICATIONS EMAIL ---
                
                // Email à l'envoyeur
                String nouveauSoldeE = String.format("%, d", envoyeur.getSolde() - totalDebitEnvoyeur);
                String msgEnvoyeur = "Confirmation d'envoi NovaCash:\n"
                                   + "Montant envoyé : " + String.format("%, d", montantBase) + " Ar\n"
                                   + "Frais d'envoi : " + String.format("%, d", fraisEnv) + " Ar\n"
                                   + (payerFraisRetrait ? "Frais de retrait payés pour le destinataire : " + String.format("%, d", fraisRetraitAVerser) + " Ar\n" : "")
                                   + "---------------------------\n"
                                   + "Total débité : " + String.format("%, d", totalDebitEnvoyeur) + " Ar\n"
                                   + "Votre nouveau solde : " + nouveauSoldeE + " Ar.";
                envoyerEmail(envoyeur.getMail(), "Confirmation d'envoi NovaCash", msgEnvoyeur);

                // Email au récepteur
                if (recepteur != null) {
                    String nouveauSoldeR = String.format("%, d", recepteur.getSolde() + montantFinalRecepteur);
                    StringBuilder msgRecepteur = new StringBuilder();
                    msgRecepteur.append("Vous avez reçu un transfert de ").append(String.format("%, d", montantBase)).append(" Ar de la part de ").append(numE).append(".\n");
                    
                    if (payerFraisRetrait) {
                        msgRecepteur.append("L'expéditeur a déjà inclus vos frais de retrait (").append(String.format("%, d", fraisRetraitAVerser)).append(" Ar).\n");
                    }
                    
                    msgRecepteur.append("Raison : ").append(raison.isEmpty() ? "Non spécifiée" : raison).append(".\n");
                    msgRecepteur.append("Montant total crédité sur votre compte : ").append(String.format("%, d", montantFinalRecepteur)).append(" Ar.\n");
                    msgRecepteur.append("Votre nouveau solde est de : ").append(nouveauSoldeR).append(" Ar.");
                    
                    envoyerEmail(recepteur.getMail(), "Réception de fonds NovaCash", msgRecepteur.toString());
                }

                response.sendRedirect("transaction.jsp?msg=success");

            }
            // --- LOGIQUE RETRAIT (Inchangée car le surplus est déjà dans le solde) ---
            else if ("retirer".equals(action)) {
                String numTel = request.getParameter("numtel");
                int montant = Integer.parseInt(request.getParameter("montant"));

                int fraisRetrait = fraisDAO.chercherFraisRecPourMontant(montant);
                int totalADebiter = montant + fraisRetrait;

                Client client = clientDAO.trouverClient(numTel);
                if (client == null || client.getSolde() < totalADebiter) {
                    response.sendRedirect("transaction.jsp?msg=error_solde");
                    return;
                }

                Retrait ret = new Retrait();
                ret.setIdrecep("RET-" + System.currentTimeMillis() / 1000);
                ret.setNumtel(numTel);
                ret.setMontant(montant);
                ret.setDaterecep(new Timestamp(System.currentTimeMillis()));

                transDAO.effectuerRetrait(ret, fraisRetrait);

                // --- NOTIFICATION EMAIL RETRAIT ---
                String nouveauSolde = String.format("%, d", client.getSolde() - totalADebiter);
                String msgRetrait = "Vous avez effectué un retrait de " + String.format("%, d", montant) + " Ar.\n"
                                  + "Frais de retrait prélevés : " + String.format("%, d", fraisRetrait) + " Ar.\n"
                                  + "Votre nouveau solde est de : " + nouveauSolde + " Ar.";
                envoyerEmail(client.getMail(), "Alerte Retrait Novacash", msgRetrait);

                response.sendRedirect("transaction.jsp?msg=success");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("transaction.jsp?msg=error");
        }
    }

    private void envoyerEmail(String to, String subject, String content) {
        if (to == null || to.isEmpty()) return;

        // --- CHARGEMENT DES VARIABLES DEPUIS LE .ENV ---
        String myEmail;
        String myPass;
        Properties env = new Properties();
        try (FileInputStream fis = new FileInputStream(getServletContext().getRealPath("/") + "../../.env")) {
            env.load(fis);
            myEmail = env.getProperty("EMAIL_USER", MON_EMAIL);
            myPass = env.getProperty("EMAIL_PASS", MON_PASS);
        } catch (IOException e) {
            // Si le chemin relatif ne marche pas dans ton Eclipse, essaie un chemin absolu pour tester
            System.out.println("Erreur chargement .env : " + e.getMessage());
            myEmail = MON_EMAIL;
            myPass = MON_PASS;
        }

        // --- CONFIGURATION SMTP ---
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");


        String finalMyEmail = myEmail;
        String finalMyPass = myPass;
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(finalMyEmail, finalMyPass);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(myEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(content);
            
            Transport.send(message);
            System.out.println("Email envoyé avec succès à " + to);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }    
}