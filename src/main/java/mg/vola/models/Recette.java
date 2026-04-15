package mg.vola.models;

import java.sql.Timestamp;

public class Recette {
    private int totalFraisEnvoi;
    private int totalFraisRetrait;

    // Getters et Setters
    public void setTotalFraisEnvoi(int t) { this.totalFraisEnvoi = t; }
    public int getTotalFraisEnvoi() { return totalFraisEnvoi; }

    public void setTotalFraisRetrait(int t) { this.totalFraisRetrait = t; }
    public int getTotalFraisRetrait() { return totalFraisRetrait; }

    // Méthode de calcul automatique
    public int getBeneficeTotal() {
        return this.totalFraisEnvoi + this.totalFraisRetrait;
    }
}