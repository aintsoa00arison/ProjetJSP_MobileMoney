package mg.vola.servlets;

import java.io.IOException;
import java.sql.SQLException;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mg.vola.dao.ClientDAO;
import mg.vola.models.Client;

@WebServlet("/ClientServlet")
public class ClientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String message = ""; // Pour stocker le type de feedback
        
        try {
            if ("ajouter".equals(action)) {
                Client c = new Client();
                c.setNumtel(request.getParameter("numtel"));
                c.setNom(request.getParameter("nom"));
                c.setSexe(request.getParameter("sexe"));
                
                String ageStr = request.getParameter("age");
                String soldeStr = request.getParameter("solde");
                c.setAge((ageStr != null && !ageStr.isEmpty()) ? Integer.parseInt(ageStr) : 0);
                c.setSolde((soldeStr != null && !soldeStr.isEmpty()) ? Integer.parseInt(soldeStr) : 0);
                c.setMail(request.getParameter("mail"));
                
                // On capture le succès ou l'échec (doublon)
                boolean cree = clientDAO.ajouterClient(c);
                message = cree ? "success" : "duplicate";
                
            } else if ("supprimer".equals(action)) {
                String numtel = request.getParameter("numtel");
                clientDAO.supprimerClient(numtel);
                message = "success";
                
            } else if ("modifier".equals(action)) {
                Client c = new Client();
                c.setNumtel(request.getParameter("numtel"));
                c.setNom(request.getParameter("nom"));
                c.setSexe(request.getParameter("sexe"));
                c.setAge(Integer.parseInt(request.getParameter("age")));
                c.setSolde(Integer.parseInt(request.getParameter("solde")));
                c.setMail(request.getParameter("mail"));
                
                clientDAO.modifierClient(c);
                message = "success";
            }

            // Redirection avec le paramètre 'msg' pour le Toast
            response.sendRedirect("liste_clients.jsp?msg=" + message);
            
        } catch (SQLException e) {
            e.printStackTrace();
            // En cas d'erreur SQL imprévue
            response.sendRedirect("liste_clients.jsp?msg=error");
        } catch (NumberFormatException e) {
            response.sendRedirect("liste_clients.jsp?msg=error");
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Souvent utilisé pour afficher la liste ou rediriger vers le formulaire
        doPost(request, response);
    }
}