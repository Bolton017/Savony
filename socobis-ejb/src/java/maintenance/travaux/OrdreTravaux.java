package maintenance.travaux;

import bean.CGenUtil;
import bean.ClassMere;

import java.sql.Connection;
import java.sql.Date;

public class OrdreTravaux extends ClassMere {
    String id,lancePar,cible,remarque,libelle,idBc;
    Date besoin,daty;
    String etatLib;

    public OrdreTravaux() throws Exception
    {
        super.setNomTable("OrdreTravaux");
        setLiaisonFille("idMere");
        setNomClasseFille("travaux.OrdreTravauxFille");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OT", "getseqORDRETRAVAUX");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLancePar() {
        return lancePar;
    }

    public void setLancePar(String lancePar) {
        this.lancePar = lancePar;
    }

    public String getCible() {
        return cible;
    }

    public void setCible(String cible) {
        this.cible = cible;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public String getIdBc() {
        return idBc;
    }

    public void setIdBc(String idBc) {
        this.idBc = idBc;
    }

    public Date getBesoin() {
        return besoin;
    }

    public void setBesoin(Date besoin) {
        this.besoin = besoin;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"id","libelle"};
    }

    @Override
    public String[] getValMotCles() {
        return new String[]{"id","libelle"};
    }

    public TravauxCpl[] getTravaux(String nomTable, Connection c) throws Exception {
        if (nomTable == null) {
            nomTable = "TRAVAUXCPL";
        }
        TravauxCpl f = new TravauxCpl();
        f.setNomTable(nomTable);
        f.setIdOf(this.getId());
        return (TravauxCpl[])(CGenUtil.rechercher(f,null,null, c, ""));
    }
}
