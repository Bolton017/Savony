package maintenance.travaux;

import stock.MvtStock;
import utilitaire.UtilDB;
import utils.ConstanteProcess;

import java.sql.Connection;

public class Travaux extends OrdreTravaux {

    String idOf;
    String idOffille;
    int niveau;
    String fabricationPrec;
    String fabricationSuiv;
    String equipe;
    double nbPetris;
    double dureeEstimatif;

    public double getDureeEstimatif() {
        return dureeEstimatif;
    }

    public void setDureeEstimatif(double dureeEstimatif) {
        this.dureeEstimatif = dureeEstimatif;
    }

    public Travaux() throws Exception {
        super.setNomTable("Travaux");
        setLiaisonFille("idMere");
        setNomClasseFille("travaux.TravauxFille");
    }
    public String[] getValMotCles() {
        String[] motCles={"id","libelle", "remarque"};
        return motCles;
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TRA", "getseqTRAVAUX");
        this.setId(makePK(c));
    }

    public String getIdOf() {
        return idOf;
    }

    public void setIdOf(String idOf) {
        this.idOf = idOf;
    }

    public String getIdOffille() {
        return idOffille;
    }

    public void setIdOffille(String idOffille) {
        this.idOffille = idOffille;
    }

    public int getNiveau() {
        return niveau;
    }

    public void setNiveau(int niveau) {
        this.niveau = niveau;
    }

    public String getFabricationPrec() {
        return fabricationPrec;
    }

    public void setFabricationPrec(String fabricationPrec) {
        this.fabricationPrec = fabricationPrec;
    }

    public String getFabricationSuiv() {
        return fabricationSuiv;
    }

    public void setFabricationSuiv(String fabricationSuiv) {
        this.fabricationSuiv = fabricationSuiv;
    }

    public String getEquipe() {
        return equipe;
    }

    public void setEquipe(String equipe) {
        this.equipe = equipe;
    }

    public double getNbPetris() {
        return nbPetris;
    }

    public void setNbPetris(double nbPetris) {
        this.nbPetris = nbPetris;
    }

    public MvtStock genererMvtStock(String typemvtstock, Connection c) throws Exception{
        String id = this.getId();
        try {
            c = new UtilDB().GetConn();
            Travaux enbase = (Travaux) this.getById(id, this.getNomTable(), c);
            MvtStock mvt = new MvtStock();
            mvt.setDesignation("Mouvement de stock du travaux : " + this.getId());
            mvt.setIdobjet(this.getId());
            mvt.setIdTypeMvStock(typemvtstock);
            mvt.setIdMagasin(enbase.getCible());
            return mvt;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Mouvement stock non generer "+e.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public Object entamerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.setEtat(ConstanteProcess.entame);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object bloquerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object terminerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            this.setEtat(ConstanteProcess.termine);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
}
