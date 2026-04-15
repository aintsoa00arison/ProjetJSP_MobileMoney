package mg.vola.models;

public class FraisEnvoi {
    private String idEnv;
    private int montant1;
    private int montant2;
    private int frais_env;

    // Constructeur vide
    public FraisEnvoi() {}

    // Getters et Setters
    public String getIdEnv() {
        return idEnv;
    }

    public void setIdEnv(String idEnv) {
        this.idEnv = idEnv;
    }

    public int getMontant1() {
        return montant1;
    }

    public void setMontant1(int montant1) {
        this.montant1 = montant1;
    }

    public int getMontant2() {
        return montant2;
    }

    public void setMontant2(int montant2) {
        this.montant2 = montant2;
    }

    public int getFrais_env() {
        return frais_env;
    }

    public void setFrais_env(int frais_env) {
        this.frais_env = frais_env;
    }
}