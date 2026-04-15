package mg.vola.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import mg.vola.models.Client;
import utils.Connexion;

public class ClientDAO {

    // 1. AJOUTER UN CLIENT (Create)
	public boolean ajouterClient(Client c) throws SQLException {
	    String checkSql = "SELECT COUNT(*) FROM client WHERE numtel = ?";
	    String sql = "INSERT INTO client (numtel, nom, sexe, age, solde, mail) VALUES (?, ?, ?, ?, ?, ?)";
	    
	    try (Connection con = Connexion.getConnection()) {
	        // 1. Vérification du doublon
	        try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
	            psCheck.setString(1, c.getNumtel());
	            ResultSet rs = psCheck.executeQuery();
	            if (rs.next() && rs.getInt(1) > 0) {
	                return false; // Le numéro existe déjà, on retourne false
	            }
	        }

	        // 2. Insertion si le numéro est unique
	        try (PreparedStatement pst = con.prepareStatement(sql)) {
	            pst.setString(1, c.getNumtel());
	            pst.setString(2, c.getNom());
	            pst.setString(3, c.getSexe());
	            pst.setInt(4, c.getAge());
	            pst.setInt(5, c.getSolde());
	            pst.setString(6, c.getMail());
	            pst.executeUpdate();
	            return true; // Succès, on retourne true
	        }
	    }
	}
    // 2. LISTER ET RECHERCHE AVEC "LIKE %...%" (Read)
    // Cette méthode remplit le point II-13 de ton sujet [cite: 13]
	public List<Client> listerClients(String recherche) throws SQLException {
	    List<Client> liste = new ArrayList<>();
	    // Requête qui cherche dans les 3 champs
	    String sql = "SELECT * FROM client WHERE nom LIKE ? OR numtel LIKE ? OR mail LIKE ? ORDER BY nom ASC";
	    
	    try (Connection con = Connexion.getConnection();
	         PreparedStatement pst = con.prepareStatement(sql)) {
	        
	        // On prépare le mot-clé avec les % pour le LIKE
	        String motCle = "%" + recherche + "%";
	        pst.setString(1, motCle);
	        pst.setString(2, motCle);
	        pst.setString(3, motCle);
	        
	        try (ResultSet rs = pst.executeQuery()) {
	            while (rs.next()) {
	                Client c = new Client();
	                c.setNumtel(rs.getString("numtel"));
	                c.setNom(rs.getString("nom"));
	                c.setSexe(rs.getString("sexe"));
	                c.setAge(rs.getInt("age"));
	                c.setSolde(rs.getInt("solde"));
	                c.setMail(rs.getString("mail"));
	                liste.add(c);
	            }
	        }
	    }
	    return liste;
	}

    // 3. MODIFIER UN CLIENT (Update)
    public void modifierClient(Client c) throws SQLException {
        String sql = "UPDATE CLIENT SET nom=?, sexe=?, age=?, solde=?, mail=? WHERE numtel=?";
        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, c.getNom());
            pst.setString(2, c.getSexe());
            pst.setInt(3, c.getAge());
            pst.setInt(4, c.getSolde());
            pst.setString(5, c.getMail());
            pst.setString(6, c.getNumtel());
            
            pst.executeUpdate();
        }
    }

    // 4. SUPPRIMER UN CLIENT (Delete)
    public void supprimerClient(String numtel) throws SQLException {
        String sql = "DELETE FROM CLIENT WHERE numtel = ?";
        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, numtel);
            pst.executeUpdate();
        }
    }
    
 // 5. TROUVER UN CLIENT PAR SON NUMÉRO (Utile pour vérifier le solde avant envoi)
    public Client trouverClient(String numtel) throws SQLException {
        String sql = "SELECT * FROM client WHERE numtel = ?";
        try (Connection con = Connexion.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, numtel);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    Client c = new Client();
                    c.setNumtel(rs.getString("numtel"));
                    c.setNom(rs.getString("nom"));
                    c.setSexe(rs.getString("sexe"));
                    c.setAge(rs.getInt("age"));
                    c.setSolde(rs.getInt("solde"));
                    c.setMail(rs.getString("mail"));
                    return c;
                }
            }
        }
        return null; // Retourne null si le numéro n'existe pas
    }
}