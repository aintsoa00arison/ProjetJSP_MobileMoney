package mg.vola.servlets;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import mg.vola.dao.TransactionDAO;
import mg.vola.dao.ClientDAO;
import mg.vola.models.Client;

@WebServlet("/RelevePdfServlet")
public class RelevePdfServlet extends HttpServlet {
    private TransactionDAO transDAO = new TransactionDAO();
    private ClientDAO clientDAO = new ClientDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String numTel = request.getParameter("numtel");
        String moisChoisi = request.getParameter("mois"); // Format attendu : "YYYY-MM" (ex: 2026-04)

        try {
            // 1. Récupération et vérification du client
            Client client = clientDAO.trouverClient(numTel);
            if (client == null) {
                response.sendRedirect("transaction.jsp?msg=error_client");
                return;
            }

            // 2. Logique pour le nom du fichier et l'affichage de la période
            String nomMois = "Inconnu";
            String annee = "";
            
            if (moisChoisi != null && moisChoisi.contains("-")) {
                String[] parts = moisChoisi.split("-");
                annee = parts[0];
                int moisIndex = Integer.parseInt(parts[1]);

                String[] moisNoms = {
                    "janvier", "fevrier", "mars", "avril", "mai", "juin",
                    "juillet", "aout", "septembre", "octobre", "novembre", "decembre"
                };
                
                if (moisIndex >= 1 && moisIndex <= 12) {
                    nomMois = moisNoms[moisIndex - 1];
                }
            }

            // Construction du nom de fichier : releve_034..._avril_2026.pdf
            String nomFichier = "releve_" + numTel + "_" + nomMois + "_" + annee + ".pdf";

            // 3. Récupération des données filtrées par mois
            List<String[]> operations = transDAO.getHistoriquePourPdf(numTel, moisChoisi);

            // 4. Configuration de la réponse PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=" + nomFichier);

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // --- DESIGN DU RELEVÉ ---

            // Titre
            Font fontTitre = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, Font.UNDERLINE);
            document.add(new Paragraph("Relevé d'opération", fontTitre));
            
            // Affichage de la période sélectionnée
            Paragraph pPeriode = new Paragraph("Période : " + nomMois.toUpperCase() + " " + annee);
            pPeriode.setAlignment(Element.ALIGN_RIGHT);
            document.add(pPeriode);
            document.add(new Paragraph("\n"));

            // Infos Client
            document.add(new Paragraph("Contact : " + client.getNumtel()));
            document.add(new Paragraph("Nom : " + client.getNom()));
            document.add(new Paragraph("Solde actuel : " + formatPoints(client.getSolde()) + " Ariary"));
            document.add(new Paragraph("\n"));

            // --- TABLEAU DES OPÉRATIONS ---
            PdfPTable table = new PdfPTable(4); 
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            
            // En-têtes (Stylisés en gris léger)
            PdfPCell cellHeader;
            String[] headers = {"Date", "Raison", "Débit", "Crédit"};
            for (String h : headers) {
                cellHeader = new PdfPCell(new Phrase(h, FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
                cellHeader.setBackgroundColor(BaseColor.LIGHT_GRAY);
                cellHeader.setPadding(5);
                table.addCell(cellHeader);
            }

            int totalDebit = 0;
            int totalCredit = 0;

            // Remplissage des lignes
            for (String[] op : operations) {
                String date = op[0];
                String raison = op[1];
                int montant = Integer.parseInt(op[2]);
                String type = op[3];

                table.addCell(date);
                table.addCell(raison != null ? raison : "Transaction");

                if ("DEBIT".equals(type)) {
                    table.addCell(formatPoints(montant));
                    table.addCell("");
                    totalDebit += montant;
                } else {
                    table.addCell("");
                    table.addCell(formatPoints(montant));
                    totalCredit += montant;
                }
            }
            document.add(table);

            // --- TOTAUX ---
            Paragraph pTotaux = new Paragraph();
            pTotaux.setSpacingBefore(15);
            pTotaux.add(new Chunk("\nTotal Débit : " + formatPoints(totalDebit) + " Ar\n"));
            pTotaux.add(new Chunk("Total Crédit : " + formatPoints(totalCredit) + " Ar"));
            document.add(pTotaux);

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la génération du PDF : " + e.getMessage());
        }
    }

    /**
     * Formate les montants avec des points comme séparateurs de milliers (ex: 50.000)
     */
    private String formatPoints(int montant) {
        return String.format("%, d", montant).replace(',', '.').trim();
    }
}