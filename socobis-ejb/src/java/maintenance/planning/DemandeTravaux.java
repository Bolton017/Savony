package maintenance.planning;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import maintenance.travaux.OrdreTravaux;
import maintenance.travaux.OrdreTravauxFille;
import maintenance.utils.ConstanteMaintenance;

import java.sql.Connection;
import java.sql.Date;

public class DemandeTravaux extends ClassEtat {
    String id;
    String idEntite;
    String idMachine;
    String idSituation;
    Date daty;
    Date dateBesoin;
    String priorite;
    int estExistant;
    String description;
    String demandeur;
    String type;
    String cause;
    String idDepartement;
    String idDepartementMaintenance;
    String idPlanning;

    public String getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(String idDepartement) {
        this.idDepartement = idDepartement;
    }

    public DemandeTravaux() {
        this.setNomTable("DemandeTravaux");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DMT", "getSeqDemandeTravaux");
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

    public String getIdEntite() {
        return idEntite;
    }

    public void setIdEntite(String idEntite) {
        this.idEntite = idEntite;
    }

    public String getIdMachine() {
        return idMachine;
    }

    public void setIdMachine(String idMachine) {
        this.idMachine = idMachine;
    }

    public String getIdSituation() {
        return idSituation;
    }

    public void setIdSituation(String idSituation) {
        this.idSituation = idSituation;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDateBesoin() {
        return dateBesoin;
    }

    public void setDateBesoin(Date dateBesoin) {
        this.dateBesoin = dateBesoin;
    }

    public String getPriorite() {
        return priorite;
    }

    public void setPriorite(String priorite) {
        this.priorite = priorite;
    }

    public int getEstExistant() {
        return estExistant;
    }

    public void setEstExistant(int estExistant) {
        this.estExistant = estExistant;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCause() {
        return cause;
    }

    public void setCause(String cause) {
        this.cause = cause;
    }

    public String getDemandeur() {
        return demandeur;
    }

    public void setDemandeur(String demandeur) {
        this.demandeur = demandeur;
    }

    public String getIdPlanning() {
        return idPlanning;
    }

    public void setIdPlanning(String idPlanning) {
        this.idPlanning = idPlanning;
    }

    @Override
    public void controler(Connection c) throws Exception {
        if (this.getIdMachine()==null || this.getIdMachine().trim().isEmpty()){
            throw new Exception("Machine invalide");
        }
        super.controler(c);
    }

    public String getIdDepartementMaintenance() {
        return idDepartementMaintenance;
    }

    public void setIdDepartementMaintenance(String idDepartementMaintenance) {
        this.idDepartementMaintenance = idDepartementMaintenance;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        System.out.println("ID DEPARTEMENT="+this.getIdDepartement());
        DemandeTravaux demande = (DemandeTravaux) super.createObject(u, c);
        if(this.getIdPlanning()==null || this.getIdPlanning().trim().isEmpty()){
            Planning planning = new Planning();
            planning.setIdMachine(this.getIdMachine());
            planning.setIdSource(demande.getId());
            planning.setDatedebut(this.daty);
            planning.setRefObjet(this.getDescription());
            planning.setEstPeriodique(0);
            planning.setIdTypeMaintenance(ConstanteMaintenance.typeMaintenanceCorrective);
            planning= (Planning) planning.createObject(u,c);
            demande.setIdPlanning(planning.getId());
            demande.updateToTableWithHisto(u,c);
        }
        else{
            demande.setIdPlanning(this.getIdPlanning());
            demande.updateToTableWithHisto(u,c);
            Planning planning = (Planning) new Planning().getById(this.getIdPlanning(),"",c);
            planning.setIdSource(demande.getId());
            planning.updateToTableWithHisto(u,c);
        }
        return demande;
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
//        if (this.getOrdreTravaux(c)==null){
//            OrdreTravaux ordreTravaux = this.genererOrdreTravaux();
//            ordreTravaux.createObject(u, c);
//        }
        Planning planning = (Planning) new Planning().getById(this.getIdPlanning(),"",c);
        if(planning!=null){
            planning.validerObject(u,c);
        }
        return super.validerObject(u, c);
    }

    public OrdreTravaux getOrdreTravaux(Connection c) throws Exception {
        OrdreTravaux ordreTravaux = new OrdreTravaux();
        ordreTravaux.setIdBc(this.getId());
        OrdreTravaux [] liste = (OrdreTravaux[]) CGenUtil.rechercher(ordreTravaux,null,null,c,"");
        if (liste.length>0){
            return liste[0];
        }
        return null;
    }

    public OrdreTravaux genererOrdreTravaux() throws Exception {
        OrdreTravaux ordreTravaux = new OrdreTravaux();
        ordreTravaux.setLancePar(this.getIdEntite());
        ordreTravaux.setIdBc(this.getId());
        ordreTravaux.setLibelle("Ordre de travaux suivant la demande "+this.getId());
        ordreTravaux.setRemarque(this.getDescription());
        ordreTravaux.setBesoin(this.getDateBesoin());

        OrdreTravauxFille[] ordreTravauxFilles = new OrdreTravauxFille[1];
        ordreTravauxFilles[0] = new OrdreTravauxFille();
        ordreTravauxFilles[0].setIdIngredients(this.getIdMachine());

        ordreTravaux.setFille(ordreTravauxFilles);

        return ordreTravaux;
    }
}
