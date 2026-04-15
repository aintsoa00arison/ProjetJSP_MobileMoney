package mg.vola.models;
import java.sql.Timestamp;

public class Envoi {
    private String idEnv;
    private String numEnvoyeur;
    private String numRecepteur;
    private int montant;
    private Timestamp date; // Type datetime 
    private boolean payer_frais_retrait; // oui ou non 
    private String raison;

    public Envoi() {}

    // Getters et Setters
    public String getIdEnv() { return idEnv; }
    public void setIdEnv(String idEnv) { this.idEnv = idEnv; }

    public String getNumEnvoyeur() { return numEnvoyeur; }
    public void setNumEnvoyeur(String numEnvoyeur) { this.numEnvoyeur = numEnvoyeur; }

    public String getNumRecepteur() { return numRecepteur; }
    public void setNumRecepteur(String numRecepteur) { this.numRecepteur = numRecepteur; }

    public int getMontant() { return montant; }
    public void setMontant(int montant) { this.montant = montant; }

    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }

    public boolean isPayer_frais_retrait() { return payer_frais_retrait; }
    public void setPayer_frais_retrait(boolean payer_frais_retrait) { this.payer_frais_retrait = payer_frais_retrait; }

    public String getRaison() { return raison; }
    public void setRaison(String raison) { this.raison = raison; }
}