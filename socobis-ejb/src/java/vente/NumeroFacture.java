package vente;
import bean.ClassEtat;

public class NumeroFacture extends ClassEtat  {
    int anne_en_cours;
    int dernier_num;
    int prochain_num;
    String prochain_num_format;

    public NumeroFacture() {
        this.setNomTable("V_NUMEROFACTURE_EN_COURS");
    }

    public int getAnne_en_cours() {
        return anne_en_cours;
    }
    public void setAnne_en_cours(int anne_en_cours) {
        this.anne_en_cours = anne_en_cours;
    }
    public int getDernier_num() {
        return dernier_num;
    }
    public void setDernier_num(int dernier_num) {
        this.dernier_num = dernier_num;
    }
    public int getProchain_num() {
        return prochain_num;
    }
    public void setProchain_num(int prochain_num) {
        this.prochain_num = prochain_num;
    }
    public String getProchain_num_format() {
        return prochain_num_format;
    }
    public void setProchain_num_format(String prochain_num_format) {
        this.prochain_num_format = prochain_num_format;
    }

    @Override
    public String getTuppleID() {
        return anne_en_cours+"";
    }

    @Override
    public String getAttributIDName() {
        return "anne_en_cours";
    }

}
