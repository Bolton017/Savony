package client;

import bean.CGenUtil;
import bean.ClassEtat;
import utils.ConstanteSavonnerie;

import java.sql.Connection;
import java.sql.Date;

public class ForfaitZoneClient extends ClassEtat {
    private String id;
    private String idZone;
    private String idingredient;
    private double tarif;
    private Date daty;
    private double puparcarton;
    private double seuilcarton;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdZone() {
        return idZone;
    }

    public void setIdZone(String idZone) {
        this.idZone = idZone;
    }

    public String getIdingredient() {
        return idingredient;
    }

    public void setIdingredient(String idingredient) {
        this.idingredient = idingredient;
    }

    public double getTarif() {
        return tarif;
    }

    public void setTarif(double tarif) {
        this.tarif = tarif;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }



    public ForfaitZoneClient() throws Exception {
        this.setNomTable("FORFAITZONECLIENT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FOZ","getseqforfaitzoneclient");
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

    public ForfaitZoneClient findForfait(String idIngredient, String idZone , Connection c) throws Exception{
        ForfaitZoneClient f = new ForfaitZoneClient();
        f.setIdingredient(idIngredient);
        f.setIdZone(idZone);
        ForfaitZoneClient[] fzcs = (ForfaitZoneClient[]) CGenUtil.rechercher(f, null, null, c, " ORDER BY daty DESC");
        if (fzcs == null || fzcs.length <= 0){
            throw new Exception("Aucun forfait trouvé pour la zone "+idZone+" et l'ingrédient "+idIngredient);
        }
        return fzcs[0];
    }

    public ForfaitZoneClient findTarifFraisLivraison(String idZone , Connection c) throws Exception{
        return findForfait(ConstanteSavonnerie.ING_FRAIS_LIVRAISON,idZone,c);
    }

    public ForfaitZoneClient findTarifForfaitLivraison(String idZone , Connection c) throws Exception{
        return  findForfait(ConstanteSavonnerie.ING_FORFAIT_LIVRAISON, idZone,c);
    }

    public double getPuparcarton() {
        return puparcarton;
    }

    public void setPuparcarton(double puparcarton) {
        this.puparcarton = puparcarton;
    }

    public double getSeuilcarton() {
        return seuilcarton;
    }

    public void setSeuilcarton(double seuilcarton) {
        this.seuilcarton = seuilcarton;
    }

    public static double calculerFraisTransport(int typefraistransport, String idZone, double qteCarton, Connection c) throws Exception {
        double fraisLivraison = 0;
        switch (typefraistransport) {
            case 1:
                fraisLivraison = calculerFraisTransport(idZone, qteCarton, c);
                break;
            case 2:
                fraisLivraison = calculerForfaitTransport(idZone, c);
                break;
            case 3:
                fraisLivraison = calculerFraisTransport(idZone, qteCarton, c);
                fraisLivraison += calculerForfaitTransport( idZone, c);
                break;
            case 0:
            default:
                break;
        }
        return fraisLivraison;
    }

    public static double calculerFraisTransport(String idZone, double qteCarton, Connection c) throws Exception {
        ForfaitZoneClient fFrais = new ForfaitZoneClient().findTarifFraisLivraison(idZone, c);
        double frais = 0;
        double puCarton = fFrais.getPuparcarton();
        double seuilcarton = fFrais.getSeuilcarton();
        if (qteCarton < seuilcarton){
            qteCarton = seuilcarton;
        }
        frais = puCarton * qteCarton;
        return frais;
    }

    public static double calculerForfaitTransport(String idZone, Connection c) throws Exception {
        ForfaitZoneClient fFrais = new ForfaitZoneClient().findTarifForfaitLivraison(idZone, c);
        return fFrais.getTarif();
    }

}

