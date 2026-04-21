package mg.vola.models;

import java.sql.Timestamp;

public class Retrait {
    private String idrecep;
    private String numtel;
    private int montant;
    private Timestamp daterecep;
    
    // Nouvelle colonne pour la recette de retrait
    private int frais_retrait;

    public Retrait() {}

    public String getIdrecep() { return idrecep; }
    public void setIdrecep(String idrecep) { this.idrecep = idrecep; }

    public String getNumtel() { return numtel; }
    public void setNumtel(String numtel) { this.numtel = numtel; }

    public int getMontant() { return montant; }
    public void setMontant(int montant) { this.montant = montant; }

    public Timestamp getDaterecep() { return daterecep; }
    public void setDaterecep(Timestamp daterecep) { this.daterecep = daterecep; }

    // Nouveau Getter et Setter
    public int getFrais_retrait() { return frais_retrait; }
    public void setFrais_retrait(int frais_retrait) { this.frais_retrait= frais_retrait; }
}