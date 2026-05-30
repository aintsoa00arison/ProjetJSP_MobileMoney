package mg.vola.servlets;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Date;

import mg.vola.dao.FraisDAO;
import mg.vola.models.FraisEnvoi;
import mg.vola.models.FraisRecep;

@WebServlet("/FraisServlet")
public class FraisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FraisDAO fraisDAO = new FraisDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération des paramètres envoyés par le formulaire
        String typeTable = request.getParameter("type_frais"); 
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        if(id == null || id.isEmpty()){
            id = new Date().toString().replaceAll("\\s","");
        }

        // Logs pour débugger dans la console de l'IDE
        System.out.println("--- DEBUG FRAIS SERVLET ---");
        System.out.println("Action: " + action);
        System.out.println("Type: " + typeTable);
        System.out.println("ID: " + id);

        try {
            String message = "";
            
            if ("ENVOI".equals(typeTable)) {
                
                if ("ajouter".equals(action) || "modifier".equals(action)) {
                    
                    // doublon de plage frais envoi
                    FraisEnvoi f = new FraisEnvoi();
                    f.setIdEnv(id);
                    f.setMontant1(Integer.parseInt(request.getParameter("montant1")));
                    f.setMontant2(Integer.parseInt(request.getParameter("montant2")));
                    f.setFrais_env(Integer.parseInt(request.getParameter("valeur")));
                    
                    if ("ajouter".equals(action)) {
                        if (fraisDAO.verifierChevauchementFraisEnvoi(Integer.parseInt(request.getParameter("montant1")), Integer.parseInt(request.getParameter("montant2")))) {
                            message = "duplicated";
                        } else {
                            fraisDAO.ajouterFraisEnv(f);
                            System.out.println("Succès: Frais Envoi ajouté");
                            message = "added";
                        }
                    } else { // Action est "modifier"
                        
                            fraisDAO.modifierFraisEnv(f);
                            System.out.println("Succès: Frais Envoi modifié");
                            message = "updated";
                        
                    }
                    
                } else if ("supprimer".equals(action)) {
                    fraisDAO.supprimerFraisEnv(id);
                    System.out.println("Succès: Frais Envoi supprimé");
                }
                
            } else if ("RECEP".equals(typeTable)) {
                
                if ("ajouter".equals(action) || "modifier".equals(action)) {

                    FraisRecep f = new FraisRecep();
                    f.setIdRec(id);
                    f.setMontant1(Integer.parseInt(request.getParameter("montant1")));
                    f.setMontant2(Integer.parseInt(request.getParameter("montant2")));
                    f.setFrais_rec(Integer.parseInt(request.getParameter("valeur")));
                    
                    if ("ajouter".equals(action)) {
                        if (fraisDAO.verifierChevauchementFraisRecep(Integer.parseInt(request.getParameter("montant1")), Integer.parseInt(request.getParameter("montant2")))) {
                            message = "duplicated";
                        } else {
                            fraisDAO.ajouterFraisRec(f);
                            System.out.println("Succès: Frais Réception ajouté");
                            message = "added";
                        }
                    } else { // Action est "modifier"
                        
                            fraisDAO.modifierFraisRec(f);
                            System.out.println("Succès: Frais Réception modifié");
                            message = "updated";
                       
                    }
                    
                } else if ("supprimer".equals(action)) {
                    fraisDAO.supprimerFraisRec(id);
                    System.out.println("Succès: Frais Réception supprimé");
                }
            }

            // Redirection vers le bon fichier physique
            response.sendRedirect("frais.jsp?msg=" + message);

        } catch (SQLException | NumberFormatException e) {
            System.err.println("ERREUR DANS FRAIS SERVLET: " + e.getMessage());
            e.printStackTrace();
            // Redirection avec message d'erreur
            response.sendRedirect("frais.jsp?msg=error");
        } catch (Exception e) {
            System.err.println("ERREUR DANS FRAIS SERVLET: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("frais.jsp?msg=error");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}