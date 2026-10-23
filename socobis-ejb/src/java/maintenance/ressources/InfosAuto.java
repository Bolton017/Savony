package maintenance.ressources;

import bean.ClassMAPTable;
import produits.Ingredients;
import maintenance.utils.ConstanteMaintenance;

import java.sql.Connection;
import java.sql.Date;

public class InfosAuto extends  ClassMAPTable{
    private String id,idIngredient,description,numeroDeParc,immatriculation,note,fournisseur,numero,
            type,vin,marque,modele,bailleur,vendeur,numeroImmobilisation,pneus,batterie,
            huileMoteur,huileboitedeVistesse,typeDeCarburant,uniteDeConsommation,typeDeCarburantLib,uniteDeConsommationLib,idIngredientLib;
    private double volume,montant;
    private int annee,nombreDePlaces,nombreDePortes,dureeEnMois,dureeAmmortissementMois;
    private Date datePremiereMiseEnCirculation,datedebut,dateAchat;

    private double puissanceFiscale, valeurInitiale, mensualite, prix;
    private double consommation;
    public InfosAuto(){
        this.setNomTable("INFOSAUTO");
    }

    @Override
    public ClassMAPTable createObject(String u , Connection c) throws Exception {
        IngredientMaintenance ingM = new IngredientMaintenance();
        ingM.setEstEngin(0);
        ingM.setLibelle(this.getDescription());
        ingM.setIdEntite(ConstanteMaintenance.ENTITE_VOITURE);
        ingM.setPu(this.getPrix());
        IngredientMaintenance ingMaintenance = (IngredientMaintenance)ingM.createObject(u,c);
        this.setIdIngredient(ingMaintenance.getIdIngredient());
        return super.createObject(u, c);
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("INA", "GETSEQINFOSAUTO");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdIngredient() {
        return idIngredient;
    }

    public void setIdIngredient(String idIngredient) {
        this.idIngredient = idIngredient;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNumeroDeParc() {
        return numeroDeParc;
    }

    public void setNumeroDeParc(String numeroDeParc) {
        this.numeroDeParc = numeroDeParc;
    }

    public String getImmatriculation() {
        return immatriculation;
    }

    public void setImmatriculation(String immatriculation) {
        this.immatriculation = immatriculation;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getFournisseur() {
        return fournisseur;
    }

    public void setFournisseur(String fournisseur) {
        this.fournisseur = fournisseur;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getVin() {
        return vin;
    }

    public void setVin(String vin) {
        this.vin = vin;
    }

    public String getMarque() {
        return marque;
    }

    public void setMarque(String marque) {
        this.marque = marque;
    }

    public String getModele() {
        return modele;
    }

    public void setModele(String modele) {
        this.modele = modele;
    }

    public String getBailleur() {
        return bailleur;
    }

    public void setBailleur(String bailleur) {
        this.bailleur = bailleur;
    }

    public String getVendeur() {
        return vendeur;
    }

    public void setVendeur(String vendeur) {
        this.vendeur = vendeur;
    }

    public String getNumeroImmobilisation() {
        return numeroImmobilisation;
    }

    public void setNumeroImmobilisation(String numeroImmobilisation) {
        this.numeroImmobilisation = numeroImmobilisation;
    }

    public String getPneus() {
        return pneus;
    }

    public void setPneus(String pneus) {
        this.pneus = pneus;
    }

    public String getBatterie() {
        return batterie;
    }

    public void setBatterie(String batterie) {
        this.batterie = batterie;
    }

    public String getHuileMoteur() {
        return huileMoteur;
    }

    public void setHuileMoteur(String huileMoteur) {
        this.huileMoteur = huileMoteur;
    }

    public String getHuileboitedeVistesse() {
        return huileboitedeVistesse;
    }

    public void setHuileboitedeVistesse(String huileboitedeVistesse) {
        this.huileboitedeVistesse = huileboitedeVistesse;
    }

    public String getTypeDeCarburant() {
        return typeDeCarburant;
    }

    public void setTypeDeCarburant(String typeDeCarburant) {
        this.typeDeCarburant = typeDeCarburant;
    }

    public String getUniteDeConsommation() {
        return uniteDeConsommation;
    }

    public void setUniteDeConsommation(String uniteDeConsommation) {
        this.uniteDeConsommation = uniteDeConsommation;
    }

    public String getTypeDeCarburantLib() {
        return typeDeCarburantLib;
    }

    public void setTypeDeCarburantLib(String typeCarburantLib) {
        this.typeDeCarburantLib = typeCarburantLib;
    }

    public String getUniteDeConsommationLib() {
        return uniteDeConsommationLib;
    }

    public void setUniteDeConsommationLib(String uniteconsolib) {
        this.uniteDeConsommationLib = uniteconsolib;
    }

    public double getVolume() {
        return volume;
    }

    public void setVolume(double volume) {
        this.volume = volume;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public int getNombreDePortes() {
        return nombreDePortes;
    }

    public void setNombreDePortes(int nombreDePortes) {
        this.nombreDePortes = nombreDePortes;
    }

    public int getDureeEnMois() {
        return dureeEnMois;
    }

    public void setDureeEnMois(int dureeEnMois) {
        this.dureeEnMois = dureeEnMois;
    }

    public int getDureeAmmortissementMois() {
        return dureeAmmortissementMois;
    }

    public void setDureeAmmortissementMois(int dureeAmmortissementMois) {
        this.dureeAmmortissementMois = dureeAmmortissementMois;
    }

    public Date getDatePremiereMiseEnCirculation() {
        return datePremiereMiseEnCirculation;
    }

    public void setDatePremiereMiseEnCirculation(Date datePremiereMiseEnCirculation) {
        this.datePremiereMiseEnCirculation = datePremiereMiseEnCirculation;
    }

    public Date getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }

    public Date getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(Date dateAchat) {
        this.dateAchat = dateAchat;
    }

    public double getPuissanceFiscale() {
        return puissanceFiscale;
    }

    public void setPuissanceFiscale(double puissanceFiscale) {
        this.puissanceFiscale = puissanceFiscale;
    }

    public double getValeurInitiale() {
        return valeurInitiale;
    }

    public void setValeurInitiale(double valeurInitiale) {
        this.valeurInitiale = valeurInitiale;
    }

    public double getMensualite() {
        return mensualite;
    }

    public void setMensualite(double mensualite) {
        this.mensualite = mensualite;
    }

    public double getPrix() {
        return prix;
    }

    public void setPrix(double prix) {
        this.prix = prix;
    }

    public double getConsommation() {
        return consommation;
    }

    public void setConsommation(double consommation) {
        this.consommation = consommation;
    }

    public int getNombreDePlaces() {
        return nombreDePlaces;
    }

    public void setNombreDePlaces(int nombreDePlaces) {
        this.nombreDePlaces = nombreDePlaces;
    }

    public String getIdIngredientLib() {
        return idIngredientLib;
    }

    public void setIdIngredientLib(String idIngredientLib) {
        this.idIngredientLib = idIngredientLib;
    }
}
