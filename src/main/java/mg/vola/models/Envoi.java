package mg.vola.models;

import java.sql.Timestamp;

public class Envoi {
    private String idEnv;
    private String numEnvoyeur;
    private String numRecepteur;
    private int montant;
    private Timestamp date;
    private boolean payer_frais_retrait;
    private String raison;
    
    // Nouvelles colonnes pour les recettes
    private int frais_env_paye; 
    private int frais_retrait_paye;

    public Envoi() {}

    // Getters et Setters existants
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

    // Nouveaux Getters et Setters pour les frais
    public int getFrais_env() { return frais_env_paye; }
    public void setFrais_env(int frais_env) { this.frais_env_paye= frais_env; }

    public int getFrais_retrait_paye() { return frais_retrait_paye; }
    public void setFrais_retrait_paye(int frais_retrait_paye) { this.frais_retrait_paye = frais_retrait_paye; }
}