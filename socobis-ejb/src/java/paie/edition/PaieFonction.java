/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paie.edition;
import bean.TypeObjet;
import java.sql.Connection;

/**
 *
 * @author ACER
 */
public class PaieFonction extends TypeObjet{
    private String idgroupefonction, gratification;

    @Override
    public String getValColLibelle(){
        return this.getVal();
    }
    public PaieFonction() {
        this.setNomTable("Paie_fonction");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getIdgroupefonction() {
        return idgroupefonction;
    }

    public void setIdgroupefonction(String idgroupefonction) {
        this.idgroupefonction = idgroupefonction;
    }

    public String getGratification() {
        return gratification;
    }

    public void setGratification(String gratification) {
        this.gratification = gratification;
    }
    public void construirePK(Connection c) throws Exception {
        super.setNomTable("Paie_fonction");
        this.preparePk("PFNC", "get_seq_Paie_fonction");
        this.setId(makePK(c));
    }
     @Override
    public String[] getMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }
   
}
