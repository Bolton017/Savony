package caisse;

import bean.AdminGen;
import bean.CGenUtil;
import utils.ConstanteAsync;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class MvtCaisseParCaissePDF extends MvtCaisse{
    private String idCaisse;
    private String idCaisseLib;
    private MvtCaisseCpl[] listeMvtCaisseCpl;
    private double montant;
    private int nbreMouvementCaisse;

    public int getNbreMouvementCaisse() {
        return nbreMouvementCaisse;
    }

    public void setNbreMouvementCaisse(int nbreMouvementCaisse) {
        this.nbreMouvementCaisse = nbreMouvementCaisse;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    @Override
    public String getIdCaisse() {
        return idCaisse;
    }

    public MvtCaisseCpl[] getListeMvtCaisseCpl() {
        return listeMvtCaisseCpl;
    }

    public String getIdCaisseLib() {
        return idCaisseLib;
    }

    @Override
    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public void setIdCaisseLib(String idCaisseLib) {
        this.idCaisseLib = idCaisseLib;
    }

    public void setListeMvtCaisseCpl(MvtCaisseCpl[] listeMvtCaisseCpl) {
        this.listeMvtCaisseCpl = listeMvtCaisseCpl;
    }

    public MvtCaisseParCaissePDF() {
    }

    public MvtCaisseParCaissePDF[] getListeMvtCaisseParCaissePDFByDate(String daty, Connection c, String idMagasin)throws Exception{
        List<MvtCaisseParCaissePDF> listeParCategoriePDF = new ArrayList<>();
        MvtCaisseCpl mvtCaisseCpl = new MvtCaisseCpl();
        mvtCaisseCpl.setNomTable("MOUVEMENTCAISSECPL_VALIDER");
        Caisse caisse = new Caisse();
        try{
            MvtCaisseCpl[] listedetailsMvt = (MvtCaisseCpl[]) CGenUtil.rechercher(mvtCaisseCpl, null, null, c, " and DATY = DATE '"+daty+"'");
            System.out.println("listedetailsMvt ++++" + listedetailsMvt.length);
            Caisse[] listeCaisse = (Caisse[]) CGenUtil.rechercher(caisse, null, null, c, "and idMagasin = '"+idMagasin+"'");
            double totalSortie = 0;
            boolean checkExisteMvt =  false;
            for (int i = 0; i < listeCaisse.length; i++) {
                System.out.println("Boucle Caisse ++++" + listeCaisse[i].getVal());
                MvtCaisseCpl[] mvtCaisseCpl_temp = (MvtCaisseCpl[]) AdminGen.find(listedetailsMvt, new String[]{"idCaisse"}, new String[]{listeCaisse[i].getId()});
                if (mvtCaisseCpl_temp != null) {
                    MvtCaisseParCaissePDF temp = new MvtCaisseParCaissePDF();
                    temp.setIdCaisse(listeCaisse[i].getId());
                    temp.setIdCaisseLib(listeCaisse[i].getVal());
                    temp.setListeMvtCaisseCpl(mvtCaisseCpl_temp);
                    temp.setMontant(AdminGen.calculSommeDouble(mvtCaisseCpl_temp,"credit"));
                    temp.setDaty(Date.valueOf(daty));
                    listeParCategoriePDF.add(temp);
                    totalSortie = totalSortie + AdminGen.calculSommeDouble(mvtCaisseCpl_temp,"debit");
                    checkExisteMvt = true;
                }
            }
            if (checkExisteMvt) {
                MvtCaisseParCaissePDF mvtCaisseSortie = new MvtCaisseParCaissePDF();
                mvtCaisseSortie.setIdCaisseLib("Mouvement de caisse");
                mvtCaisseSortie.setMontant(-totalSortie);
                MvtCaisseCpl[] mvtCaisseCpl_temp = new MvtCaisseCpl[1];
                mvtCaisseCpl_temp[0] = new MvtCaisseCpl();
                mvtCaisseCpl_temp[0].setIdCaisseLib("Mouvement de caisse");
                mvtCaisseCpl_temp[0].setDebit(totalSortie);
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate localDate = LocalDate.parse(daty, formatter);
                Date sqlDate = Date.valueOf(localDate);
                mvtCaisseCpl_temp[0].setDaty(sqlDate);
                mvtCaisseSortie.setListeMvtCaisseCpl(mvtCaisseCpl_temp);
                listeParCategoriePDF.add(mvtCaisseSortie);
            }
            MvtCaisseParCaissePDF[] retour = new MvtCaisseParCaissePDF[listeParCategoriePDF.size()];
            listeParCategoriePDF.toArray(retour);
            return retour;
        }catch (Exception ex){
            throw ex;
        }
    }

    public MvtCaisseParCaissePDF[] getSummaryParCaisse(String daty, Connection c, String idMagasin)throws Exception{
        List<MvtCaisseParCaissePDF> listeParCategoriePDF = new ArrayList<>();
        MvtCaisseCpl mvtCaisseCpl = new MvtCaisseCpl();
        mvtCaisseCpl.setNomTable("MVTCAISSE_PDFCLOTURE");
        Caisse caisse = new Caisse();
        try{
            MvtCaisseCpl[] listedetailsMvt = (MvtCaisseCpl[]) CGenUtil.rechercher(mvtCaisseCpl, null, null, c, " and DATY = DATE '"+daty+"'");
            Caisse[] listeCaisse = (Caisse[]) CGenUtil.rechercher(caisse, null, null, c, "and idMagasin = '"+idMagasin+"'");
            for (int i = 0; i < listeCaisse.length; i++) {
                if (listeCaisse[i].getId().compareTo(ConstanteAsync.CAISSE_ESPECE) != 0 ){
                    System.out.println("Boucle Caisse ++++" + listeCaisse[i].getVal());
                    MvtCaisseCpl[] mvtCaisseCpl_temp = (MvtCaisseCpl[]) AdminGen.find(listedetailsMvt, new String[]{"idCaisse"}, new String[]{listeCaisse[i].getId()});
                    MvtCaisseParCaissePDF temp = new MvtCaisseParCaissePDF();
                    temp.setIdCaisse(listeCaisse[i].getId());
                    temp.setIdCaisseLib(listeCaisse[i].getVal());
                    temp.setDaty(Date.valueOf(daty));
                    if (mvtCaisseCpl_temp != null) {
                        temp.setMontant(AdminGen.calculSommeDouble(mvtCaisseCpl_temp,"credit"));
                        temp.setNbreMouvementCaisse(mvtCaisseCpl_temp.length);
                    }else{
                        temp.setMontant(0);
                        temp.setNbreMouvementCaisse(0);
                    }
                    listeParCategoriePDF.add(temp);
                }

            }
            MvtCaisseParCaissePDF[] retour = new MvtCaisseParCaissePDF[listeParCategoriePDF.size()];
            listeParCategoriePDF.toArray(retour);
            System.out.println("Taille Summary ++++" + retour.length);
            return retour;
        }catch (Exception ex){
            throw ex;
        }
    }

}
