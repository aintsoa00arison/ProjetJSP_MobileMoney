package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.FileInputStream;
import java.util.Properties;
import java.io.File;

public class Connexion {
    
    public static Connection getConnection() {
        Connection con = null;
        Properties env = new Properties();
        
        // --- CHEMIN ABSOLU DIRECT ---
        String path = "D:/GestionMobileMoney/.env";
        File envFile = new File(path);

        if (envFile.exists()) {
            try (FileInputStream fis = new FileInputStream(envFile)) {
                env.load(fis);
                System.out.println("✅ .env chargé depuis le chemin absolu : " + path);
            } catch (Exception e) {
                System.err.println("❌ Erreur de lecture du fichier .env : " + e.getMessage());
            }
        } else {
            System.out.println("⚠️ Fichier .env introuvable à : " + path + ". Utilisation des valeurs par défaut.");
        }

        // --- RÉCUPÉRATION DES VARIABLES (Avec tes valeurs par défaut) ---
        String url = env.getProperty("DB_URL", "jdbc:postgresql://localhost:5432/mobilemoney");
        String user = env.getProperty("DB_USER", "postgres");
        String password = env.getProperty("DB_PASSWORD", "1234");

        // --- CONNEXION ---
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            System.err.println("ERREUR CONNEXION DB: " + e.getMessage());
        }
        
        return con;
    }
}