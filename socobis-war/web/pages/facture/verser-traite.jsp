<%-- 
    Document   : transfert-caisse
    Created on : 16 janv. 2021, 00:42:39
    Author     : Sanda
--%>

<%@page import="utilitaire.Constante"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="affichage.Liste"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="user.UserEJB"%> 
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="facture.tr.MvttIntraCaisse" %>
<%@ page import="facture.tr.MvtIntraCaisseFille" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="utils.ConstanteVente" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "facture.tr.MvttIntraCaisse", classeFille = "facture.tr.MvtIntraCaisseFille",
                nomtable = "mvtintracaisse", nomTableFille = "mvtintracaisse_fille",
                apres = "facture/traite-fiche.jsp", colonneMere = "idmere",
                titre = "Transfert traite";
        int taille = 10;
        MvttIntraCaisse objet = new MvttIntraCaisse();
        objet.setNomTable(nomtable);
        MvtIntraCaisseFille fille = new MvtIntraCaisseFille();
        fille.setNomTable(nomTableFille);
        //PageInsertMultiple pi = new PageInsertMultiple(objet, fille, request, taille, u);
        PageInsert pi = new PageInsert(objet, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        if (request.getParameter("ids") != null) {
            double somme = objet.calculerSomme(request.getParameter("ids"));
            pi.getFormu().getChamp("montant").setDefaut(Utilitaire.formaterAr(somme));
            if (objet.getListeJournal() != null) {
                //pi.getFormu().getChamp("caissedepart").setDefaut((objet.getListeJournal())[0].getCaisse().getId());
                for (int i = 0; i < (objet.getListeJournal()).length; i++) {
                    //pi.getFormufle().getChamp("reference_" + i).setDefaut((objet.getListeJournal())[i].getNumcheque());
                }
            }
        }
        if (request.getParameter("montant") != null) {
            String montant = java.net.URLDecoder.decode(request.getParameter("montant"), "UTF-8");
            pi.getFormu().getChamp("montant").setDefaut(montant);
        }
        if (request.getParameter("idTraite") != null) {
            pi.getFormu().getChamp("idTraite").setDefaut(request.getParameter("idTraite"));
        }
        affichage.Champ[] liste = new affichage.Champ[3]; ///////
        Caisse listedepart = new Caisse();
        listedepart.setNomTable("caisse");

        Caisse listearriver = new Caisse();
        listearriver.setNomTable("caisse");

       
        
        if (request.getParameter("caissedepart") != null) {
            listedepart.setNomTable(request.getParameter("caissedepart"));
        }

        liste[0] = new Liste("caissedepart", listedepart, "val", "id");
        liste[0].setDefaut("CAIS00000T00016");
        liste[1] = new Liste("caissearrivee", listearriver, "val", "id");
        liste[1].setDefaut("CAIS000017");
        
        TypeObjet liste3 = new TypeObjet();
        liste3.setNomTable("caisse");
        liste[2] = new Liste("idfinaledestination", liste3, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idTraite").setLibelle("Traite");
        pi.getFormu().getChamp("idTraite").setAutre("readonly");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("remarque").setVisible(false);
        pi.getFormu().getChamp("caissedepart").setLibelle("D&eacute;part");
        pi.getFormu().getChamp("etatversement").setVisible(false);
        pi.getFormu().getChamp("idfinaledestination").setLibelle(" Caisse");

        pi.getFormu().getChamp("caissedepart").setAutre("readonly");
        pi.getFormu().getChamp("caissearrivee").setAutre("readonly");
        pi.getFormu().getChamp("caissearrivee").setLibelle("Arriv&eacute;e");

        if (request.getParameter("idTraite") != null) {
            liste[1].setDefaut(ConstanteVente.EFFETSARECEVOIRREMISALENCAISSEMENT);
        } else {
            pi.getFormu().getChamp("caissearrivee").setDefaut(request.getParameter("banque"));
        }
        pi.getFormu().getChamp("modepaiement").setVisible(false);
        pi.getFormu().getChamp("designation").setVisible(false);
        pi.getFormu().getChamp("montant").setAutre("readonly");
        /*pi.getFormufle().getChamp("Reference_0").setLibelle("R&eacute;ference");
        pi.getFormufle().getChamp("Remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("Idmere_0").setVisible(false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idmere"), false);*/

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            //pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormu().getHtmlInsert());
            //out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="viserTraiteSimple">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=pi.getNombreLigne()%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="idTraite" type="hidden" id="idTraite" value="<%=request.getParameter("idTraite")%>">
        <input name="id" type="hidden" id="id" value="<%=request.getParameter("idTraite")%>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();</script>
    <% }%>
