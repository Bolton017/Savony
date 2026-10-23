<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>
<%@ page import="client.Client" %>
<%@ page import="bean.TypeObjet" %>
<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "client.Client",
                nomtable = "CLIENT",
                apres = "mobile/fiche-client.jsp",
                titre = "Ajouter un client";

        Client caisse = new Client();
        PageInsert pi = new PageInsert(caisse, request, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[1];
        TypeObjet type = new TypeObjet("TYPECLIENT");
        liste[0] = new Liste("idTypeClient",type,"val","id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("nom").setLibelle("Nom propri&eacute;taire");
        pi.getFormu().getChamp("telephone").setLibelle("Contact");
        pi.getFormu().getChamp("adresse").setLibelle("Localisation");
        pi.getFormu().getChamp("adresse").setAutre("readonly data-localisation-input=\"true\"");
        pi.getFormu().getChamp("idTypeClient").setLibelle("Cat&eacute;gorie");
        pi.getFormu().getChamp("payeur").setLibelle("Magasin");
        pi.getFormu().getChamp("remarque").setDefaut(""+u.getUser().getRefuser());
        pi.getFormu().getChamp("remarque").setVisible(false);
        pi.getFormu().getChamp("compte").setVisible(false);
        pi.getFormu().getChamp("mail").setVisible(false);
        pi.getFormu().getChamp("compteauxiliaire").setVisible(false);
        pi.getFormu().getChamp("idprovince").setVisible(false);
        pi.getFormu().getChamp("echeance").setVisible(false);
        pi.getFormu().getChamp("telfixe").setVisible(false);
        pi.getFormu().getChamp("nif").setVisible(false);
        pi.getFormu().getChamp("stat").setVisible(false);
        pi.getFormu().getChamp("carte").setVisible(false);
        pi.getFormu().getChamp("datecarte").setVisible(false);
        pi.getFormu().getChamp("taxe").setVisible(false);
        pi.getFormu().getChamp("codeclient").setVisible(false);
        pi.getFormu().getChamp("estactif").setVisible(false);
        pi.getFormu().getChamp("idzoneclient").setVisible(false);
        pi.getFormu().getChamp("idmodepaiement").setVisible(false);
        pi.getFormu().getChamp("cin").setVisible(false);
        pi.getFormu().getChamp("delai").setVisible(false);
        pi.getFormu().getChamp("idtarification").setVisible(false);
        pi.getFormu().getChamp("idpoint").setVisible(false);
        pi.getFormu().getChamp("image").setVisible(false);
        pi.getFormu().ajouterChampAttacherFichier();

        String[] ordre = {"nom", "payeur", "telephone", "adresse", "idTypeClient"};
        pi.getFormu().setOrdre(ordre);

        pi.preparerDataFormu();
        if(request.getParameter("acte")!=null){
            titre = "Modification d'un client";
        }
%>

<div class="content-wrapper saisie-client-page"
     data-localisation-url="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/localisation.jsp">
    <jsp:include page="/pages/elements/headerMobile.jsp">
        <jsp:param name="titre" value="Saisie d'un Client"/>
    </jsp:include>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
