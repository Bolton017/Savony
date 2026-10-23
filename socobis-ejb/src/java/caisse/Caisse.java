/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package caisse;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDateTime;
import magasin.Magasin;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteStation;

/**
 *
 * @author nouta
 */
public class Caisse extends ClassEtat{ 
    private String id,val,desce,idTypeCaisse,idPoint,idCategorieCaisse,compte,idMagasin,idDevise;
    private String idTypeBanque;
    private String estRib;

    public static Caisse getCaisseParCat(Caisse[] liste,String cat) throws Exception
    {
        if(liste==null || liste.length==0) return null;
        String[] col={"idCategorieCaisse"};
        String[] val={cat};
        Caisse [] lc=(Caisse[]) AdminGen.find(liste,col,val);
        if(lc==null || lc.length==0) return null;
        return lc[0];
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public Caisse() {
        super.setNomTable("caisse");
    }

    public Caisse(String idPoint) {
        super.setNomTable("caisse");
        this.idPoint = idPoint;
    }

    public String getIdTypeBanque() {
        return idTypeBanque;
    }

    public void setIdTypeBanque(String idTypeBanque) {
        this.idTypeBanque = idTypeBanque;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }

    public String getIdTypeCaisse() {
        return idTypeCaisse;
    }

    public void setIdTypeCaisse(String idTypeCaisse) {
        this.idTypeCaisse = idTypeCaisse;
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }


    public String getIdCategorieCaisse() {
        return idCategorieCaisse;
    }

    public void setIdCategorieCaisse(String idCategorieCaisse) {
        this.idCategorieCaisse = idCategorieCaisse;
    }

    public String getCompte() {
	 return compte;
    }

    public void setCompte(String compte) {
	 this.compte = compte;
    }

    
    
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CAI", "GETSEQCAISSE");
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

    public String getIdDevise() {
	 return idDevise;
    }

    public void setIdDevise(String idDevise) {
	 this.idDevise = idDevise;
    }

    
    
    protected ReportCaisse createReportCaisse() throws Exception {
        ReportCaisse r = new ReportCaisse();
        r.setIdCaisse(this.getId());
        Date datedujour = Utilitaire.dateDuJourSql();
        LocalDateTime localDateTime = datedujour.toLocalDate().atStartOfDay().minusDays(1);
        Date datehier = Date.valueOf(localDateTime.toLocalDate());
        r.setDaty(datehier);
        r.setMontant(0);   
        return r;
    }
    public Magasin getMagasin(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Magasin[] magasin = (Magasin[]) CGenUtil.rechercher(new Magasin(), null, null, c, "and id='"+this.getIdMagasin()+"'");
         if (magasin.length > 0) {
            return magasin[0];
        }
        return null;
    }
   
    
    @Override
    public Object validerObject(String u, Connection c) throws Exception { 
        ReportCaisse r = createReportCaisse();
        r.createObject(u, c);
        r.validerObject(u, c);
        if (getMode().compareTo("modif") != 0) {
            Magasin m=getMagasin(c);
            if (m != null) {
                setIdPoint(m.getIdPoint());
            }
        }
        return super.validerObject(u, c); 
    }
    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception { 
        Magasin m=getMagasin(c);
        if (m != null) {
            setIdPoint(m.getIdPoint());
        }
        return super.createObject(u, c); 
    }
    @Override
    public String getValColLibelle() {
        return this.val;
    }
   
    public Caisse getCaisse(Connection c) throws Exception {
        if (c == null) {
            throw new Exception("Connection non etablie");
        }
        Caisse[] encaissements = (Caisse[]) CGenUtil.rechercher(this, null, null, c,"");
        if (encaissements.length > 0) {
            return encaissements[0];
        }
        return null;
    }
    
    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }
    @Override
    public String[] getValMotCles() {
        String[] motCles={"val","desce"};
        return motCles;
    }

    public Caisse[] getByTypeBanque(String idTypeBanque, Connection c) throws Exception {
        Caisse s = new Caisse();
        s.setIdTypeBanque(idTypeBanque);

        return (Caisse[]) CGenUtil.rechercher(s, null, null, c, "");
    }

    public String[] getIdCaisseByTypeBanque(String idTypeBanque, Connection c) throws Exception {
        boolean localConnection = false;

        if (c == null) {
            c = new UtilDB().GetConn();
            localConnection = true;
        }

        try {
            Caisse[] cs = getByTypeBanque(idTypeBanque, c);

            String[] res = new String[cs.length];
            for (int i = 0; i < cs.length; i++) {
                res[i] = cs[i].getId();
            }

            return res;
        } finally {
            if (localConnection && c != null) {
                c.close();
            }
        }
    }

    public String getEstRib() {
        return estRib;
    }

    public void setEstRib(String estRib) {
        this.estRib = estRib;
    }
}
