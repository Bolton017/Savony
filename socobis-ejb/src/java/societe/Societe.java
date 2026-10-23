package societe;

import bean.ClassMAPTable;
import utilitaire.Utilitaire;

public class Societe extends ClassMAPTable
{

    public Societe(String d, String no, String reg, String adr, String phone, String fa, String mai,
                   String ger, String ni, String sta, String r, String cap, String b1, String b2,
                   String log, String t, String q, String enti)
    {
        super.setNomTable("MaSociete");
        setIdSpat(d);
        setNom(no);
        setRegime(reg);
        setAdresse(adr);
        setTelephone(phone);
        setFax(fa);
        setEMail(mai);
        setGerant(ger);
        setNif(ni);
        setNumStat(sta);
        setRc(r);
        setCapital(cap);
        setBanque1(b1);
        setBanque2(b2);
        setLogo(log);
        setTp(t);
        setQuittance(q);
        setEntite(enti);
    }

    public Societe() {
        super.setNomTable("MaSociete");
    }

    public Societe(String no, String reg, String adr, String phone, String fa, String mai, String ger,
                   String ni, String sta, String r, String cap, String b1, String b2, String log,
                   String t, String q, String enti)
    {
        super.setNomTable("MaSociete");
        setIdSpat(String.valueOf(Utilitaire.getMaxSeq("getSeqMaSociete")));
        if(no.compareTo("") == 0 || no == null)
            setNom("-");
        else
            setNom(no);
        if(reg.compareTo("") == 0 || reg == null)
            setRegime("-");
        else
            setRegime(reg);
        if(adr.compareTo("") == 0 || adr == null)
            setAdresse("-");
        else
            setAdresse(adr);
        if(phone.compareTo("") == 0 || phone == null)
            setTelephone("-");
        else
            setTelephone(phone);
        if(fa.compareTo("") == 0 || fa == null)
            setFax("-");
        else
            setFax(fa);
        if(mai.compareTo("") == 0 || mai == null)
            setEMail("-");
        else
            setEMail(mai);
        if(ger.compareTo("") == 0 || ger == null)
            setGerant("-");
        else
            setGerant(ger);
        if(ni.compareTo("") == 0 || ni == null)
            setNif("-");
        else
            setNif(ni);
        if(sta.compareTo("") == 0 || sta == null)
            setNumStat("-");
        else
            setNumStat(sta);
        if(r.compareTo("") == 0 || r == null)
            setRc("-");
        else
            setRc(r);
        if(cap.compareTo("") == 0 || cap == null)
            setCapital("-");
        else
            setCapital(cap);
        if(b1.compareTo("") == 0 || b1 == null)
            setBanque1("-");
        else
            setBanque1(b1);
        if(b2.compareTo("") == 0 || b2 == null)
            setBanque2("-");
        else
            setBanque2(b2);
        if(log.compareTo("") == 0 || log == null)
            setLogo("-");
        else
            setLogo(log);
        if(t.compareTo("") == 0 || t == null)
            setTp("-");
        else
            setTp(t);
        if(q.compareTo("") == 0 || q == null)
            setQuittance("-");
        else
            setQuittance(q);
        if(enti.compareTo("") == 0 || enti == null)
            setEntite("BE011");
        else
            setEntite(enti);
    }

    public String getAttributIDName()
    {
        return "idSpat";
    }

    public String getTuppleID()
    {
        return String.valueOf(idSpat);
    }

    public void setIdSpat(String idSpat)
    {
        this.idSpat = idSpat;
    }

    public String getIdSpat()
    {
        return idSpat;
    }

    public void setNom(String nom)
    {
        this.nom = nom;
    }

    public String getNom()
    {
        return nom;
    }

    public void setRegime(String regime)
    {
        this.regime = regime;
    }

    public String getRegime()
    {
        return regime;
    }

    public void setAdresse(String adresse)
    {
        this.adresse = adresse;
    }

    public String getAdresse()
    {
        return adresse;
    }

    public void setTelephone(String telephone)
    {
        this.telephone = telephone;
    }

    public String getTelephone()
    {
        return telephone;
    }

    public void setFax(String fax)
    {
        this.fax = fax;
    }

    public String getFax()
    {
        return fax;
    }

    public void setEMail(String eMail)
    {
        this.eMail = eMail;
    }

    public String getEMail()
    {
        return eMail;
    }

    public void setGerant(String gerant)
    {
        this.gerant = gerant;
    }

    public String getGerant()
    {
        return gerant;
    }

    public void setNif(String nif)
    {
        this.nif = nif;
    }

    public String getNif()
    {
        return nif;
    }

    public void setNumStat(String numStat)
    {
        this.numStat = numStat;
    }

    public String getNumStat()
    {
        return numStat;
    }

    public void setRc(String rc)
    {
        this.rc = rc;
    }

    public String getRc()
    {
        return rc;
    }

    public void setCapital(String capital)
    {
        this.capital = capital;
    }

    public String getCapital()
    {
        return capital;
    }

    public void setBanque1(String banque1)
    {
        this.banque1 = banque1;
    }

    public String getBanque1()
    {
        return banque1;
    }

    public void setBanque2(String banque2)
    {
        this.banque2 = banque2;
    }

    public String getBanque2()
    {
        return banque2;
    }

    public void setLogo(String logo)
    {
        this.logo = logo;
    }

    public String getLogo()
    {
        return logo;
    }

    public void setTp(String tp)
    {
        this.tp = tp;
    }

    public String getTp()
    {
        return tp;
    }

    public void setQuittance(String quittance)
    {
        this.quittance = quittance;
    }

    public String getQuittance()
    {
        return quittance;
    }
    public void setEntite(String entite) {
        this.entite = entite;
    }
    public String getEntite() {
        return entite;
    }

    public String getCf() {
        return cf;
    }

    public void setCf(String cf) {
        this.cf = cf;
    }

    public String getDisponnibilite() {
        return disponnibilite;
    }

    public void setDisponnibilite(String disponnibilite) {
        this.disponnibilite = disponnibilite;
    }

    public String getAdresse_centre() {
        return adresse_centre;
    }

    public void setAdresse_centre(String adresse_centre) {
        this.adresse_centre = adresse_centre;
    }

    public String getCentre_fiscal() {
        return centre_fiscal;
    }

    public void setCentre_fiscal(String centre_fiscal) {
        this.centre_fiscal = centre_fiscal;
    }

    public String idSpat;
    public String nom;
    public String regime;
    public String adresse;
    public String telephone;
    public String fax;
    public String eMail;
    public String gerant;
    public String nif;
    public String numStat;
    public String rc;
    public String capital;
    public String banque1;
    public String banque2;
    public String logo;
    public String tp;
    public String quittance;

    public String entite , disponnibilite, cf , adresse_centre , centre_fiscal;
    public String logoHeader, favicon;

    public String getFavicon() {
        return favicon;
    }

    public void setFavicon(String favicon) {
        this.favicon = favicon;
    }

    public String getLogoHeader() {
        return logoHeader;
    }

    public void setLogoHeader(String logoHeader) {
        this.logoHeader = logoHeader;
    }

    public String geteMail() {
        return eMail;
    }

    public void seteMail(String eMail) {
        this.eMail = eMail;
    }
}
