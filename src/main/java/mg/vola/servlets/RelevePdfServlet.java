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

        try {
            // 1. Récupération des données
            Client client = clientDAO.trouverClient(numTel);
            if (client == null) {
                response.sendRedirect("transaction.jsp?msg=error_client");
                return;
            }
            
            List<String[]> operations = transDAO.getHistoriquePourPdf(numTel);

            // 2. Configuration du PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=releve_" + numTel + ".pdf");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // --- DESIGN DU RELEVÉ (Basé sur ton image) ---

            // Titre
            Font fontTitre = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, Font.UNDERLINE);
            document.add(new Paragraph("Exemple d'un relevé d'opération", fontTitre));
            
            // Date du jour (ou mois sélectionné)
            Paragraph pDate = new Paragraph("Date : Avril 2024");
            pDate.setAlignment(Element.ALIGN_RIGHT);
            document.add(pDate);
            document.add(new Paragraph("\n"));

            // Infos Client
            document.add(new Paragraph("Contact : " + client.getNumtel()));
            document.add(new Paragraph(client.getNom()));
            document.add(new Paragraph("Solde actuel : " + formatPoints(client.getSolde()) + " Ariary"));
            document.add(new Paragraph("\n"));

            // --- TABLEAU ---
            PdfPTable table = new PdfPTable(4); 
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            
            // En-têtes
            table.addCell("Date");
            table.addCell("Raison");
            table.addCell("Débit");
            table.addCell("Crédit");

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

            // --- TOTAUX (Bas de l'image) ---
            document.add(new Paragraph("\nTotal Débit : " + formatPoints(totalDebit) + " Ar"));
            document.add(new Paragraph("Total Crédit : " + formatPoints(totalCredit) + " Ar"));

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la génération du PDF : " + e.getMessage());
        }
    }

    // Fonction pour avoir les points comme sur ton image (50.000)
    private String formatPoints(int montant) {
        return String.format("%, d", montant).replace(',', '.').trim();
    }
}