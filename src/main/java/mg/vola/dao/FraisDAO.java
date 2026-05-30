package mg.vola.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import mg.vola.models.FraisEnvoi;
import mg.vola.models.FraisRecep;
import utils.Connexion;

public class FraisDAO {

    // ==========================================================
    // CRUD POUR FRAIS_ENVOI (Table FRAIS_ENVOI)
    // ==========================================================

    public void ajouterFraisEnv(FraisEnvoi f) throws Exception {
        String sql = "INSERT INTO FRAIS_ENVOI (idEnv, montant1, montant2, frais_env) VALUES (?, ?, ?, ?)";
        if(f.getMontant1() > f.getMontant2()){
            throw new Exception("Montant 1 doit etre inférieur au montant 2");
        }

        List<FraisEnvoi> liste_frais = listerFraisEnv();
        for (FraisEnvoi fraisEnvoi : liste_frais) {
            if(f.getMontant1() <= fraisEnvoi.getMontant2() && f.getMontant2() >= fraisEnvoi.getMontant1()){
                throw new Exception("intervalle existant");
            }
        }

        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, f.getIdEnv());
            pst.setInt(2, f.getMontant1());
            pst.setInt(3, f.getMontant2());
            pst.setInt(4, f.getFrais_env());
            pst.executeUpdate();
        }
    }

    public List<FraisEnvoi> listerFraisEnv() throws SQLException {
        List<FraisEnvoi> liste = new ArrayList<>();
        String sql = "SELECT * FROM FRAIS_ENVOI ORDER BY montant1";
        try (Connection con = Connexion.getConnection(); 
             Statement st = con.createStatement(); 
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                FraisEnvoi f = new FraisEnvoi();
                f.setIdEnv(rs.getString("idEnv"));
                f.setMontant1(rs.getInt("montant1"));
                f.setMontant2(rs.getInt("montant2"));
                f.setFrais_env(rs.getInt("frais_env"));
                liste.add(f);
            }
        }
        return liste;
    }

    public void modifierFraisEnv(FraisEnvoi f) throws SQLException {
        String sql = "UPDATE FRAIS_ENVOI SET montant1 = ?, montant2 = ?, frais_env = ? WHERE idEnv = ?";
        try (Connection con = Connexion.getConnection(); 
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, f.getMontant1());
            pst.setInt(2, f.getMontant2());
            pst.setInt(3, f.getFrais_env());
            pst.setString(4, f.getIdEnv());
            pst.executeUpdate();
        }
    }

    public void supprimerFraisEnv(String idEnv) throws SQLException {
        String sql = "DELETE FROM FRAIS_ENVOI WHERE idEnv = ?";
        try (Connection con = Connexion.getConnection(); 
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, idEnv);
            pst.executeUpdate();
        }
    }

    // ==========================================================
    // CRUD POUR FRAIS_RECEP (Table FRAIS_RECEP)
    // ==========================================================

    public void ajouterFraisRec(FraisRecep f) throws SQLException,Exception {
        String sql = "INSERT INTO FRAIS_RECEP (idRec, montant1, montant2, frais_rec) VALUES (?, ?, ?, ?)";

        if(f.getMontant1() > f.getMontant2()){
            throw new Exception("Montant 1 doit etre inférieur au montant 2");
        }

        List<FraisRecep> liste_frais = listerFraisRec();
        for (FraisRecep frais : liste_frais) {
            if(f.getMontant1() <= frais.getMontant2() && f.getMontant2() >= frais.getMontant1()){
                throw new Exception("intervalle existant");
            }
        }

        try (Connection con = Connexion.getConnection(); 
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, f.getIdRec());
            pst.setInt(2, f.getMontant1());
            pst.setInt(3, f.getMontant2());
            pst.setInt(4, f.getFrais_rec());
            pst.executeUpdate();
        }
    }

    public List<FraisRecep> listerFraisRec() throws SQLException {
        List<FraisRecep> liste = new ArrayList<>();
        String sql = "SELECT * FROM FRAIS_RECEP ORDER BY montant1";
        try (Connection con = Connexion.getConnection(); 
             Statement st = con.createStatement(); 
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                FraisRecep f = new FraisRecep();
                f.setIdRec(rs.getString("idRec"));
                f.setMontant1(rs.getInt("montant1"));
                f.setMontant2(rs.getInt("montant2"));
                f.setFrais_rec(rs.getInt("frais_rec"));
                liste.add(f);
            }
        }
        return liste;
    }

    public void modifierFraisRec(FraisRecep f) throws SQLException {
        String sql = "UPDATE FRAIS_RECEP SET montant1 = ?, montant2 = ?, frais_rec = ? WHERE idRec = ?";
        try (Connection con = Connexion.getConnection(); 
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, f.getMontant1());
            pst.setInt(2, f.getMontant2());
            pst.setInt(3, f.getFrais_rec());
            pst.setString(4, f.getIdRec());
            pst.executeUpdate();
        }
    }

    public void supprimerFraisRec(String idRec) throws SQLException {
        String sql = "DELETE FROM FRAIS_RECEP WHERE idRec = ?";
        try (Connection con = Connexion.getConnection(); 
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, idRec);
            pst.executeUpdate();
        }
    }
 // CHERCHER LE FRAIS D'ENVOI (Table FRAIS_ENVOI)
    public int chercherFraisPourMontant(int montant) throws SQLException {
        // On utilise >= et <= pour être certain de prendre les bornes exactes
        String sql = "SELECT frais_env FROM FRAIS_ENVOI WHERE montant1 <= ? AND montant2 >= ?";
        
        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setInt(1, montant); // Le montant est plus grand ou égal au minimum
            pst.setInt(2, montant); // Le montant est plus petit ou égal au maximum
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    int resultat = rs.getInt("frais_env");
                    System.out.println("LOG DAO: Frais trouvé pour " + montant + " = " + resultat);
                    return resultat;
                } else {
                    System.out.println("LOG DAO: Aucun frais trouvé pour le montant " + montant);
                }
            }
        }
        return 0;
    }
    // CHERCHER LE FRAIS DE RÉCEPTION/RETRAIT (Table FRAIS_RECEP)
    public int chercherFraisRecPourMontant(int montant) throws SQLException {
        String sql = "SELECT frais_rec FROM FRAIS_RECEP WHERE ? BETWEEN montant1 AND montant2";
        
        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setInt(1, montant);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("frais_rec");
                }
            }
        }
        return 0;
    }

    public boolean verifierChevauchementFraisEnvoi(int m1, int m2) throws SQLException {
    String sql = "SELECT COUNT(*) FROM frais_envoi WHERE montant1 <= ? AND montant2 >= ?";
    
    try (Connection con = Connexion.getConnection();
         PreparedStatement pst = con.prepareStatement(sql)) {
        
        pst.setInt(1, m2); 
        pst.setInt(2, m1);
        
        try (ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0; 
            }
        }
    }
    return false;
}
    public boolean verifierChevauchementFraisRecep(int m1, int m2) throws SQLException {
    String sql = "SELECT COUNT(*) FROM frais_recep WHERE montant1 <= ? AND montant2 >= ? ";
    
    try (Connection con = Connexion.getConnection();
         PreparedStatement pst = con.prepareStatement(sql)) {
        
        pst.setInt(1, m2); 
        pst.setInt(2, m1);
        
        try (ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0; // Retourne true si un chevauchement existe
            }
        }
    }
    return false;
}

}