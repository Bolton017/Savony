package entretien;

import bean.ClassEtat;
import paie.employe.EmployeComplet;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;

public class Entretient extends ClassEtat{

    private String id;
    private String idCandidature;
    private String idInterviewer;
    private Date dateEntretient;
    private double score;
    private String remarque;
    private String etatlib;
    private String idCandidatLib;
    private String idInterviewerLib;

    public Entretient() throws Exception {
        super.setNomTable("entretient");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ENTR", "getSeqEntretien");
        this.setId(makePK(c));
    }
    public String getEtatlib() {
        return etatlib;
    }
    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCandidature() {
        return idCandidature;
    }

    public void setIdCandidature(String idCandidature) {
        this.idCandidature = idCandidature;
    }

    public String getIdInterviewer() {
        return idInterviewer;
    }

    public void setIdInterviewer(String idInterviewer) {
        this.idInterviewer = idInterviewer;
    }


    public void setDateEntretient(Date dateEntretient) {
        this.dateEntretient = dateEntretient;
    }
    public Date getDateEntretient() {
        return dateEntretient;
    }


    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }
     @Override
    public String getTuppleID() { return this.id; }

    @Override
    public String getAttributIDName() { return "id"; }

    public String getIdCandidatLib() {
        return idCandidatLib;
    }

    public void setIdCandidatLib(String idCandidatLib) {
        this.idCandidatLib = idCandidatLib;
    }

    public String getIdInterviewerLib() {
        return idInterviewerLib;
    }

    public void setIdInterviewerLib(String idInterviewerLib) {
        this.idInterviewerLib = idInterviewerLib;
    }
    public EmployeComplet genererPersonnel(Connection c)throws Exception
    {
        boolean estOuvert=false;
        try
        {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert=true;
            }
            
            EntretientLib etr=new EntretientLib();
            EntretientLib bl = (EntretientLib) etr.getById(this.getId(),"V_ENTRETIENT",c);           
            
            
            EmployeComplet mv=new EmployeComplet();
            mv.setNom(bl.getNom());
            mv.setPrenom(bl.getPrenom());
            mv.setTelephone(bl.getTelephone());
            mv.setMail(bl.getEmail());
            mv.setDate_naissance(bl.getDateNaissance());
            return mv;
        }
        catch(Exception e)
        {
            throw e;
        }
        finally
        {
            if(c!=null&&estOuvert==true)c.close();
        }
    }
}