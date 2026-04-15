package mg.vola.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mg.vola.dao.FraisDAO;

@WebServlet("/CalculFraisServlet")
public class CalculFraisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FraisDAO fraisDAO = new FraisDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // GROS MESSAGE DANS LA CONSOLE ECLIPSE
        System.out.println("==============================================");
        System.out.println("🚀 APPEL DU SERVLET DE CALCUL REÇU !");
        
        try {
            String mStr = request.getParameter("montant");
            String rStr = request.getParameter("retrait");
            System.out.println("💰 Montant reçu : " + mStr + " | Retrait : " + rStr);

            int montant = Integer.parseInt(mStr);
            boolean avecRetrait = Boolean.parseBoolean(rStr);
            
            int fEnv = fraisDAO.chercherFraisPourMontant(montant);
            int fRet = avecRetrait ? fraisDAO.chercherFraisRecPourMontant(montant) : 0;
            
            System.out.println("✅ Résultats BDD -> Envoi: " + fEnv + " | Retrait: " + fRet);
            System.out.println("==============================================");

            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(fEnv + "," + fRet);
            
        } catch (Exception e) {
            System.err.println("❌ ERREUR SERVLET : " + e.getMessage());
            response.setStatus(500);
            response.getWriter().write("0,0");
        }
    }
}