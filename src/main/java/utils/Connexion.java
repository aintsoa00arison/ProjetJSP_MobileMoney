package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.FileInputStream;
import java.util.Properties;
import java.io.File;

public class Connexion {
    
    public static Connection getConnection() {
        Connection con = null;
        try {
            Properties env = new Properties();
            
            // On essaie de trouver le fichier .env à la racine du projet
            // Dans Eclipse/Tomcat, la racine est souvent le dossier de l'IDE
            // On va tester plusieurs chemins possibles pour être sûr
            String path = System.getProperty("user.dir") + File.separator + ".env";
            
            try (FileInputStream fis = new FileInputStream(path)) {
                env.load(fis);
            } catch (Exception e) {
                // Si ça échoue, on peut mettre un chemin fixe pour le développement
                System.out.println("DEBUG: .env non trouvé à " + path + ". Utilisation des valeurs par défaut.");
            }

            // Lecture des variables (si le fichier n'existe pas, on met des valeurs de secours)
            String url = env.getProperty("DB_URL", "jdbc:postgresql://localhost:5432/MobileMoneyData");
            String user = env.getProperty("DB_USER", "postgres");
            String password = env.getProperty("DB_PASSWORD", "123");

            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, user, password);
            
        } catch (Exception e) {
            System.err.println("ERREUR CONNEXION DB: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}