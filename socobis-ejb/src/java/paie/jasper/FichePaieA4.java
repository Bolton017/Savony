/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.jasper;

import java.util.ArrayList;
import java.util.List;
import paie.edition.FichePaie;

/**
 *
 * @author anthonyandrianaivoravelona
 */
public class FichePaieA4 {

    private List<FichePaie> fiche_paie_1, fiche_paie_2, fiche_paie_3, fiche_paie_4;

    public FichePaieA4(List<FichePaie> fiche_paie_1, List<FichePaie> fiche_paie_2, List<FichePaie> fiche_paie_3, List<FichePaie> fiche_paie_4) {
        this.fiche_paie_1 = fiche_paie_1;
        this.fiche_paie_2 = fiche_paie_2;
        this.fiche_paie_3 = fiche_paie_3;
        this.fiche_paie_4 = fiche_paie_4;
    }

    public FichePaieA4() {
    }

    public List<FichePaie> getFiche_paie_1() {
        return fiche_paie_1;
    }

    public void setFiche_paie_1(List<FichePaie> fiche_paie_1) {
        this.fiche_paie_1 = fiche_paie_1;
    }

    public List<FichePaie> getFiche_paie_2() {
        return fiche_paie_2;
    }

    public void setFiche_paie_2(List<FichePaie> fiche_paie_2) {
        this.fiche_paie_2 = fiche_paie_2;
    }

    public List<FichePaie> getFiche_paie_3() {
        return fiche_paie_3;
    }

    public void setFiche_paie_3(List<FichePaie> fiche_paie_3) {
        this.fiche_paie_3 = fiche_paie_3;
    }

    public List<FichePaie> getFiche_paie_4() {
        return fiche_paie_4;
    }

    public void setFiche_paie_4(List<FichePaie> fiche_paie_4) {
        this.fiche_paie_4 = fiche_paie_4;
    }

    public static List<FichePaieA4> listFichePaieA4(List<FichePaie> ls) {
        List<FichePaieA4> ls_rs = new ArrayList<FichePaieA4>();
        int indiceFichePaie = 0;
        int nombrePage = 0;
        int resteFPSLenght = ls.size() % 4;
        if (resteFPSLenght == 0) {
            nombrePage = ls.size() / 4;
        } else {
            nombrePage = (ls.size() / 4) + 1;
        }
        for (int i = 0, l = nombrePage; i < l; i++) {
            FichePaie[] fichePaieGal = new FichePaie[4];
            int indiceFichePaieGal = 0;
            for (int e = indiceFichePaie; e < ls.size(); e++) {
                if (indiceFichePaieGal == 4) {
                    indiceFichePaieGal = 0;
                    break;
                }
                fichePaieGal[indiceFichePaieGal] = ls.get(e);
                indiceFichePaieGal++;
                indiceFichePaie++;
            }
            FichePaieA4 fichePaie14 = new FichePaieA4();
            List<FichePaie> fp1 = new ArrayList<FichePaie>();
            List<FichePaie> fp2 = new ArrayList<FichePaie>();
            List<FichePaie> fp3 = new ArrayList<FichePaie>();
            List<FichePaie> fp4 = new ArrayList<FichePaie>();
            if (fichePaieGal[0] != null) {
                fp1.add(fichePaieGal[0]);
            }
            if (fichePaieGal[1] != null) {
                fp2.add(fichePaieGal[1]);
            }
            if (fichePaieGal[2] != null) {
                fp3.add(fichePaieGal[2]);
            }
            if (fichePaieGal[3] != null) {
                fp4.add(fichePaieGal[3]);
            }
            fichePaie14.setFiche_paie_1(!fp1.isEmpty() ? fp1 : null);
            fichePaie14.setFiche_paie_2(!fp2.isEmpty() ? fp2 : null);
            fichePaie14.setFiche_paie_3(!fp3.isEmpty() ? fp3 : null);
            fichePaie14.setFiche_paie_4(!fp4.isEmpty() ? fp4 : null);
            ls_rs.add(fichePaie14);
        }
        return ls_rs;
    }

}
