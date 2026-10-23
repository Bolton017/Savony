<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="rapprochement.Relever" %>
<%@ page import="rapprochement.ReleverDetail" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "rapprochement.Relever";
    String classeFille = "rapprochement.ReleverDetail";
    String nomTableFille = "RELEVERDETAIL";
    String colonneMere = "idMere";
    String apres = "rapprochement/fiche-relever.jsp";

    Relever mere = new Relever();
    mere.setNomTable("RELEVER");
    ReleverDetail fille = new ReleverDetail();
    fille.setNomTable("RELEVERDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d' un rapprochement");

    Liste[] liste = new Liste[1];
    Caisse liste0 = new Caisse();
    liste0.setNomTable("CAISSEBANQUE");
    liste[0] = new Liste("idCaisse",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idCaisse").setLibelle("Banque");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("datyDebut").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("datyFin").setLibelle("Date de fin");
    pi.getFormu().getChamp("etat").setVisible(false);


    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date");
    pi.getFormufle().getChamp("debit_0").setLibelle("D&eacute;bit");
    pi.getFormufle().getChamp("credit_0").setLibelle("Cr&eacute;dit");
    pi.getFormufle().getChamp("datyvaleur_0").setLibelle("Date de valeur");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("solde").getListeChamp(),false);

    String[] colOrdre = {"designation","daty","debit","credit","datyvaleur"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d' un rapprochement");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

