package mg.vola.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import mg.vola.models.Envoi;
import mg.vola.models.Recette;
import mg.vola.models.Retrait;
import utils.Connexion;

public class TransactionDAO {

	// 1. ENVOYER DE L'ARGENT (Mise à jour pour inclure les frais)
	public void effectuerEnvoi(Envoi env, int fraisEnv, int fraisRetraitPaye) throws SQLException {
	    Connection con = Connexion.getConnection();
	    try {
	        con.setAutoCommit(false); 

	        // AJOUT des colonnes frais_env et frais_retrait_paye
	        String sqlEnvoi = "INSERT INTO envoi (idenv, numenvoyeur, numrecepteur, montant, date, payer_frais_retrait, raison, frais_env, frais_retrait_paye) VALUES (?,?,?,?,?,?,?,?,?)";
	        PreparedStatement pstEnv = con.prepareStatement(sqlEnvoi);
	        pstEnv.setString(1, env.getIdEnv());
	        pstEnv.setString(2, env.getNumEnvoyeur());
	        pstEnv.setString(3, env.getNumRecepteur());
	        pstEnv.setInt(4, env.getMontant());
	        pstEnv.setTimestamp(5, env.getDate());
	        pstEnv.setBoolean(6, env.isPayer_frais_retrait());
	        pstEnv.setString(7, env.getRaison());
	        pstEnv.setInt(8, fraisEnv);          // <--- Nouvelle colonne
	        pstEnv.setInt(9, fraisRetraitPaye);  // <--- Nouvelle colonne (sera 0 si non coché)
	        pstEnv.executeUpdate();

	        // Calcul du débit total pour l'envoyeur
	        int totalADebiter = env.getMontant() + fraisEnv; 
	        // Note: Si payer_frais_retrait est vrai, fraisRetraitPaye a été ajouté au montant de l'objet Envoi 
	        // dans le servlet, donc c'est déjà inclus dans env.getMontant().

	        String sqlUpEnvoyeur = "UPDATE client SET solde = solde - ? WHERE numtel = ?";
	        PreparedStatement pstUpE = con.prepareStatement(sqlUpEnvoyeur);
	        pstUpE.setInt(1, totalADebiter);
	        pstUpE.setString(2, env.getNumEnvoyeur());
	        pstUpE.executeUpdate();

	        String sqlUpRecepteur = "UPDATE client SET solde = solde + ? WHERE numtel = ?";
	        PreparedStatement pstUpR = con.prepareStatement(sqlUpRecepteur);
	        pstUpR.setInt(1, env.getMontant());
	        pstUpR.setString(2, env.getNumRecepteur());
	        pstUpR.executeUpdate();

	        con.commit(); 
	    } catch (SQLException e) {
	        if (con != null) con.rollback(); 
	        throw e;
	    } finally {
	        if (con != null) con.close();
	    }
	}


	// 2. LISTER LES DERNIERS ENVOIS
    public List<Envoi> listerDerniersEnvois() throws SQLException {
        List<Envoi> liste = new ArrayList<>();
        // Sélection uniquement des colonnes existantes
        String sql = "SELECT idenv, numenvoyeur, numrecepteur, montant, date, payer_frais_retrait, raison FROM envoi ORDER BY date DESC LIMIT 10";
        
        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                Envoi e = new Envoi();
                e.setIdEnv(rs.getString("idenv"));
                e.setNumEnvoyeur(rs.getString("numenvoyeur"));
                e.setNumRecepteur(rs.getString("numrecepteur"));
                e.setMontant(rs.getInt("montant"));
                e.setDate(rs.getTimestamp("date"));
                e.setPayer_frais_retrait(rs.getBoolean("payer_frais_retrait"));
                e.setRaison(rs.getString("raison"));
                liste.add(e);
            }
        }
        return liste;
    }

	// 3. EFFECTUER UN RETRAIT (Mise à jour pour inclure les frais)
	public void effectuerRetrait(Retrait ret, int fraisRetrait) throws SQLException {
	    Connection con = Connexion.getConnection();
	    try {
	        con.setAutoCommit(false);

	        // AJOUT de la colonne frais_retrait
	        String sqlRet = "INSERT INTO retrait (idrecep, numtel, montant, daterecep, frais_retrait) VALUES (?,?,?,?,?)";
	        PreparedStatement pst = con.prepareStatement(sqlRet);
	        pst.setString(1, ret.getIdrecep());
	        pst.setString(2, ret.getNumtel());
	        pst.setInt(3, ret.getMontant());
	        pst.setTimestamp(4, ret.getDaterecep());
	        pst.setInt(5, fraisRetrait); // <--- Nouvelle colonne
	        pst.executeUpdate();

	        String sqlUp = "UPDATE client SET solde = solde - ? WHERE numtel = ?";
	        PreparedStatement pstUp = con.prepareStatement(sqlUp);
	        pstUp.setInt(1, ret.getMontant() + fraisRetrait);
	        pstUp.setString(2, ret.getNumtel());
	        pstUp.executeUpdate();

	        con.commit();
	    } catch (SQLException e) {
	        if (con != null) con.rollback();
	        throw e;
	    } finally {
	        if (con != null) con.close();
	    }
	}

  // 4. LISTER LES DERNIERS RETRAITS
    public List<Retrait> listerDerniersRetraits() throws SQLException {
        List<Retrait> liste = new ArrayList<>();
        // Requête sur la table retrait (tout en minuscule)
        String sql = "SELECT idrecep, numtel, montant, daterecep FROM retrait ORDER BY daterecep DESC LIMIT 10";
        
        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                Retrait r = new Retrait();
                r.setIdrecep(rs.getString("idrecep"));
                r.setNumtel(rs.getString("numtel"));
                r.setMontant(rs.getInt("montant"));
                r.setDaterecep(rs.getTimestamp("daterecep"));
                liste.add(r);
            }
        }
        return liste;
    }
    // 5. RECETTE TOTALE
    public Recette calculerRecettesGlobales() throws SQLException {
        Recette recette = new Recette();
        
        // On somme les frais d'envoi ET les frais de retrait payés par l'envoyeur
        String sqlEnvoi = "SELECT SUM(frais_env_paye)FROM envoi";
        // On somme les frais de retrait payés lors d'un retrait au guichet
        String sqlRetrait = "SELECT SUM(frais_retrait_paye) FROM retrait";

        try (Connection con = Connexion.getConnection()) {
            try (PreparedStatement pst = con.prepareStatement(sqlEnvoi);
                 ResultSet rs = pst.executeQuery()) {
                if (rs.next()) recette.setTotalFraisEnvoi(rs.getInt(1));
            }

            try (PreparedStatement pst = con.prepareStatement(sqlRetrait);
                 ResultSet rs = pst.executeQuery()) {
                if (rs.next()) recette.setTotalFraisRetrait(rs.getInt(1));
            }
        }
        return recette;
    }
    
    public List<String[]> getHistoriquePourPdf(String numTel, String moisFiltre) throws SQLException {
        List<String[]> liste = new ArrayList<>();
        
        // moisFiltre sera sous la forme "2024-04"
        String sql = 
            "SELECT date::text as d, raison::text as r, montant::integer as m, 'DEBIT'::text as t " +
            "FROM envoi WHERE numenvoyeur = ? AND to_char(date, 'YYYY-MM') = ? " +
            "UNION ALL " +
            "SELECT daterecep::text, 'Retrait d''argent'::text, montant::integer, 'DEBIT'::text " +
            "FROM retrait WHERE numtel = ? AND to_char(daterecep, 'YYYY-MM') = ? " +
            "UNION ALL " +
            "SELECT date::text, raison::text, montant::integer, 'CREDIT'::text " +
            "FROM envoi WHERE numrecepteur = ? AND to_char(date, 'YYYY-MM') = ? " +
            "ORDER BY 1 ASC";

        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, numTel);
            pst.setString(2, moisFiltre);
            pst.setString(3, numTel);
            pst.setString(4, moisFiltre);
            pst.setString(5, numTel);
            pst.setString(6, moisFiltre);
            
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    String dateBrute = rs.getString(1);
                    String datePropre = (dateBrute != null && dateBrute.length() >= 10) ? dateBrute.substring(0, 10) : dateBrute;

                    liste.add(new String[]{
                        datePropre, 
                        rs.getString(2), 
                        String.valueOf(rs.getInt(3)), 
                        rs.getString(4)
                    });
                }
            }
        }
        return liste;
    }
}