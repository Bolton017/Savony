package rapprochement;

import bean.ClassMAPTable;

import java.sql.Date;

public class ResultatRapprochement extends ClassMAPTable {
    private String id;

    private String idSousEcriture;
    private String idReleverDetail;

    private double debit;
    private double credit;

    private Date datySousEcriture;
    private Date datyReleveDetail;

    private String designationSousEcriture;
    private String designationReleveDetail;

    public ResultatRapprochement() {
        setNomTable("ResultatRapprochement");
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

    public String getIdSousEcriture() {
        return idSousEcriture;
    }

    public void setIdSousEcriture(String idSousEcriture) {
        this.idSousEcriture = idSousEcriture;
    }

    public String getIdReleverDetail() {
        return idReleverDetail;
    }

    public void setIdReleverDetail(String idReleverDetail) {
        this.idReleverDetail = idReleverDetail;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) {
        this.debit = debit;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public Date getDatySousEcriture() {
        return datySousEcriture;
    }

    public void setDatySousEcriture(Date datySousEcriture) {
        this.datySousEcriture = datySousEcriture;
    }

    public Date getDatyReleveDetail() {
        return datyReleveDetail;
    }

    public void setDatyReleveDetail(Date datyReleveDetail) {
        this.datyReleveDetail = datyReleveDetail;
    }

    public String getDesignationSousEcriture() {
        return designationSousEcriture;
    }

    public void setDesignationSousEcriture(String designationSousEcriture) {
        this.designationSousEcriture = designationSousEcriture;
    }

    public String getDesignationReleveDetail() {
        return designationReleveDetail;
    }

    public void setDesignationReleveDetail(String designationReleveDetail) {
        this.designationReleveDetail = designationReleveDetail;
    }
}
