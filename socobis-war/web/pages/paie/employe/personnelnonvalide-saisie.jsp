<%--
    Document   : personnelnonvalide
    Created on : 23 nov. 2020, 14:39:11
    Author     : ASUS
--%>

<%@page import="paie.log.LogPersonnelNonValide"%>
<%@page import="utilitaire.Constante"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageInsert"%>
<%
    UserEJB u = (UserEJB) session.getAttribute("u");
    String autreparsley = "data-parsley-range='[8, 40]' required";
    LogPersonnelNonValide a = new LogPersonnelNonValide();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    String idpers = request.getParameter("id");
    if (idpers != null && idpers.compareTo("") != 0) {
        pi.getFormu().getChamp("idlogpers").setDefaut(idpers);
    }

    affichage.Champ[] liste = new affichage.Champ[1];
    TypeObjet typeDepart = new TypeObjet();
    typeDepart.setNomTable("type_depart");
    liste[0] = new Liste("idtypedebauche", typeDepart, "val", "id");
    pi.getFormu().changerEnChamp(liste);

    //TypeObjet m = new TypeObjet();
    //m.setNomTable("DEC_DECISION_TYPE");
    //liste[0]=new Liste("idtypedebauche",m,"VAL","ID");

    /* TypeObjet categorieItem = new TypeObjet();
    categorieItem.setNomTable("DEC_DECISION_CATEGORIE");
    TypeObjet[] categorie = (TypeObjet[]) u.getData(categorieItem, null, null, null, " AND DESCE = '" + Constante.depart + "'");
    String whereDec = (categorie != null && categorie.length > 0) ? " AND DESCE = '" + categorie[0].getId() + "'" : " AND 2>1";
    TypeObjet motifItem = new TypeObjet();
    motifItem.setNomTable("DEC_DECISION_TYPE");
    TypeObjet[] motif = (TypeObjet[]) u.getData(motifItem, null, null, null, whereDec);
    if (motif != null && motif.length > 0) {
        liste[0] = new Liste("idtypedebauche");
        ((Liste) liste[0]).makeListeFromArray("val", "id", motif);
        pi.getFormu().changerEnChamp(liste);
    } else {
        String[] aff = {"   -   "};
        String[] val = {"-"};
        Liste lis = new Liste("idtypedebauche");
        lis.makeListeString(aff, val);
        liste[0] = lis;
        pi.getFormu().changerEnChamp(liste);
    }*/



    pi.getFormu().getChamp("idlogpers").setLibelle("Personnel");
    pi.getFormu().getChamp("idpassation").setLibelle("Passation de service");
//    pi.getFormu().getChamp("idpassation").setAutre("readonly='readonly'");
    pi.getFormu().getChamp("date_decision").setLibelle("Date de d&eacute;cision");
    pi.getFormu().getChamp("dateapplication").setLibelle("Date d'application");
    pi.getFormu().getChamp("date_decision").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("idtypedebauche").setLibelle("Type du d&eacute;part");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idavancement").setVisible(false);
    pi.getFormu().getChamp("refdecision").setLibelle("R&eacute;f&eacute;rence de d&eacute;cision");
    pi.getFormu().getChamp("motif").setLibelle("Motif");

    pi.getFormu().getChamp("date_reintegration").setVisible(false);
    pi.getFormu().getChamp("idlogpers").setPageAppelComplete("paie.log.LogPersonnelValide","id","log_personnel_v2");
    pi.getFormu().getChamp("idpassation").setPageAppelComplete("paie.log.LogPersonnelValide","id","log_personnel_v2");

    pi.getFormu().getChamp("dureePreavis").setLibelle("Dur&eacute;e de pr&eacute;avis (en jours)");
    pi.getFormu().getChamp("stc").setLibelle("Solde de Tout Compte (STC)");
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 align="center">Saisie d'un d&eacute;part</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="debauche" id="debauche"  data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="paie/employe/personnelnonvalide-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="paie.log.LogPersonnelNonValide">
    </form>
</div>
