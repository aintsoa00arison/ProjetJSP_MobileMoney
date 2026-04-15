package mg.vola.models;

public class Client {
    private String numtel; // Clé primaire 
    private String nom;
    private String sexe;
    private int age;
    private int solde;
    private String mail;

    public Client() {}

    // Getters et Setters
    public String getNumtel() { return numtel; }
    public void setNumtel(String numtel) { this.numtel = numtel; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getSexe() { return sexe; }
    public void setSexe(String sexe) { this.sexe = sexe; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public int getSolde() { return solde; }
    public void setSolde(int solde) { this.solde = solde; }

    public String getMail() { return mail; }
    public void setMail(String mail) { this.mail = mail; }
}