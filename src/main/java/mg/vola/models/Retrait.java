package mg.vola.models;
import java.sql.Timestamp;

public class Retrait {
    private String idrecep;
    private String numtel;
    private int montant;
    private Timestamp daterecep; // Type datetime 

    public Retrait() {}

    // Getters et Setters
    public String getIdrecep() { return idrecep; }
    public void setIdrecep(String idrecep) { this.idrecep = idrecep; }

    public String getNumtel() { return numtel; }
    public void setNumtel(String numtel) { this.numtel = numtel; }

    public int getMontant() { return montant; }
    public void setMontant(int montant) { this.montant = montant; }

    public Timestamp getDaterecep() { return daterecep; }
    public void setDaterecep(Timestamp daterecep) { this.daterecep = daterecep; }
}