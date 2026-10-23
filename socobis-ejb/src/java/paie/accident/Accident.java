package paie.accident;

import bean.ClassEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;

public class Accident extends ClassEtat {
    private String id;
    private Date daty;
    private Date date_Declaration;
    private String id_Personnel;
    private String id_Lieu;
    private String id_Type_Accident;
    private String id_Gravite;
    private String id_Machine;
    private String cause;
    private String heureAccident;
    private String horaireDebut;
    private String horaireFin;
    private String activite;
    private String lesions;
    private String centreSoin;
    private String detailsTemoin1;
    private String detailsTemoin2;

    private String    faitAccident;
    private int       type;
    private String    numeroRapport;
    private String    actionImmediate;
    private String    analyseCause;
    private String    actionCorrective;
    private String    responsable,idSociete,auteurRapport,descriptionAccident,descriptionBlessure,descriptionDommageMateriel,representantCSST,responsableLieu,compliance;

    public String getFaitAccident() {
        return faitAccident;
    }

    public String getIdSociete() {
        return idSociete;
    }

    public String getCompliance() {
        return compliance;
    }

    public void setCompliance(String compliance) {
        this.compliance = compliance;
    }

    public void setIdSociete(String idSociete) {
        this.idSociete = idSociete;
    }

    public String getAuteurRapport() {
        return auteurRapport;
    }

    public void setAuteurRapport(String auteurRapport) {
        this.auteurRapport = auteurRapport;
    }

    public String getDescriptionAccident() {
        return descriptionAccident;
    }

    public void setDescriptionAccident(String descriptionAccident) {
        this.descriptionAccident = descriptionAccident;
    }

    public String getDescriptionBlessure() {
        return descriptionBlessure;
    }

    public void setDescriptionBlessure(String descriptionBlessure) {
        this.descriptionBlessure = descriptionBlessure;
    }

    public String getDescriptionDommageMateriel() {
        return descriptionDommageMateriel;
    }

    public void setDescriptionDommageMateriel(String descriptionDommageMateriel) {
        this.descriptionDommageMateriel = descriptionDommageMateriel;
    }

    public String getRepresentantCSST() {
        return representantCSST;
    }

    public void setRepresentantCSST(String representantCSST) {
        this.representantCSST = representantCSST;
    }

    public String getResponsableLieu() {
        return responsableLieu;
    }

    public void setResponsableLieu(String responsableLieu) {
        this.responsableLieu = responsableLieu;
    }

    public void setFaitAccident(String faitAccident) {
        this.faitAccident = faitAccident;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getNumeroRapport() {
        return numeroRapport;
    }

    public void setNumeroRapport(String numeroRapport) {
        this.numeroRapport = numeroRapport;
    }

    public String getActionImmediate() {
        return actionImmediate;
    }

    public void setActionImmediate(String actionImmediate) {
        this.actionImmediate = actionImmediate;
    }

    public String getAnalyseCause() {
        return analyseCause;
    }

    public void setAnalyseCause(String analyseCause) {
        this.analyseCause = analyseCause;
    }

    public String getActionCorrective() {
        return actionCorrective;
    }

    public void setActionCorrective(String actionCorrective) {
        this.actionCorrective = actionCorrective;
    }

    public String getResponsable() {
        return responsable;
    }

    public void setResponsable(String responsable) {
        this.responsable = responsable;
    }

    public String getHeureAccident() {
        return heureAccident;
    }

    public void setHeureAccident(String heureAccident) {
        this.heureAccident = heureAccident;
    }

    public String getHoraireDebut() {
        return horaireDebut;
    }

    public void setHoraireDebut(String horaireDebut) {
        this.horaireDebut = horaireDebut;
    }

    public String getHoraireFin() {
        return horaireFin;
    }

    public void setHoraireFin(String horaireFin) {
        this.horaireFin = horaireFin;
    }

    public String getActivite() {
        return activite;
    }

    public void setActivite(String activite) {
        this.activite = activite;
    }

    public String getLesions() {
        return lesions;
    }

    public void setLesions(String lesions) {
        this.lesions = lesions;
    }

    public String getCentreSoin() {
        return centreSoin;
    }

    public void setCentreSoin(String centreSoin) {
        this.centreSoin = centreSoin;
    }

    public String getDetailsTemoin1() {
        return detailsTemoin1;
    }

    public void setDetailsTemoin1(String detailsTemoin1) {
        this.detailsTemoin1 = detailsTemoin1;
    }

    public String getDetailsTemoin2() {
        return detailsTemoin2;
    }

    public void setDetailsTemoin2(String detailsTemoin2) {
        this.detailsTemoin2 = detailsTemoin2;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDate_Declaration() {
        return date_Declaration;
    }

    public void setDate_Declaration(Date date_Declaration) {
        this.date_Declaration = date_Declaration;
    }

    public String getId_Personnel() {
        return id_Personnel;
    }

    public void setId_Personnel(String id_Personnel) {
        this.id_Personnel = id_Personnel;
    }

    public String getId_Lieu() {
        return id_Lieu;
    }

    public void setId_Lieu(String id_Lieu) {
        this.id_Lieu = id_Lieu;
    }

    public String getId_Type_Accident() {
        return id_Type_Accident;
    }

    public void setId_Type_Accident(String id_Type_Accident) {
        this.id_Type_Accident = id_Type_Accident;
    }

    public String getId_Gravite() {
        return id_Gravite;
    }

    public void setId_Gravite(String id_Gravite) {
        this.id_Gravite = id_Gravite;
    }

    public String getId_Machine() {
        return id_Machine;
    }

    public void setId_Machine(String id_Machine) {
        this.id_Machine = id_Machine;
    }

    public String getCause() {
        return cause;
    }

    public void setCause(String cause) {
        this.cause = cause;
    }



    public Accident() throws Exception {
        this.setNomTable("ACCIDENT");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("ACD","getSeqAccident");
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

    public java.util.Map<String, Integer> getNombreAccidentParMachineEtDate(String machineId, Date dateDebut, Date dateFin) throws Exception {
        Connection con = null;
        java.util.Map<String, Integer> result = new java.util.LinkedHashMap<>();
        try {
            con = (new UtilDB()).GetConn();
            StringBuilder query = new StringBuilder("SELECT TO_CHAR(daty, 'YYYY-MM-DD') as date_accident, COUNT(*) as nombre FROM ACCIDENT WHERE 1=1");

            if(machineId != null && !machineId.isEmpty()) {
                query.append(" AND id_Machine = '").append(machineId).append("'");
            }
            if(dateDebut != null) {
                query.append(" AND daty >= TO_DATE('").append(dateDebut.toString()).append("', 'YYYY-MM-DD')");
            }
            if(dateFin != null) {
                query.append(" AND daty <= TO_DATE('").append(dateFin.toString()).append("', 'YYYY-MM-DD')");
            }

            query.append(" GROUP BY TO_CHAR(daty, 'YYYY-MM-DD') ORDER BY TO_CHAR(daty, 'YYYY-MM-DD')");

            java.sql.Statement stmt = con.createStatement();
            java.sql.ResultSet rs = stmt.executeQuery(query.toString());
            while(rs.next()) {
                String date = rs.getString("date_accident");
                int nombre = rs.getInt("nombre");
                result.put(date, nombre);
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if(con != null) con.close();
        }
        return result;
    }

    public void checkDateAccident() throws Exception {
        if (this.getDaty() != null) {
            long diffMillis = Utilitaire.dateDuJourSql().getTime() - this.getDaty().getTime();
            long diffJours = diffMillis / (1000 * 60 * 60 * 24);
            if (diffJours > 2) {
                throw new Exception("La déclaration doit être faite dans les 2 jours suivant l'accident. Délai dépassé de " + (diffJours - 2) + " jour(s)");
            }
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        this.checkDateAccident();
        this.setDate_Declaration(Utilitaire.dateDuJourSql());
        this.updateToTableWithHisto(u,c);
        return super.validerObject(u, c);
    }
}

