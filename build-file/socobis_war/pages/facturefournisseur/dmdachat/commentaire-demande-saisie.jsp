<%@page import="faturefournisseur.CommentaireDemande"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>

<%
    try {
        UserEJB u = (UserEJB) session.getValue("u");

        String mapping = "faturefournisseur.CommentaireDemande";
        String nomtable = "commentaireDemande";
        String idObjet = request.getParameter("id");
        String apres = request.getParameter("bute");
        apres = apres + "&tab=inc/commentaire-liste&id="+idObjet;
        String titre = "Nouveau Commentaire";

        if (request.getParameter("acte") != null) {
            titre = "Modification Commentaire";
        }

        CommentaireDemande comDem = new CommentaireDemande();
        comDem.setNomTable(nomtable);

        PageInsert pi = new PageInsert(comDem, request, u);
        pi.setLien((String) session.getValue("lien"));
        if (idObjet != null) {
            pi.getFormu().getChamp("idObjet").setDefaut(idObjet);
        }
        pi.getFormu().getChamp("idObjet").setVisible(false);
        pi.getFormu().getChamp("nomUser").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("commentaire").setLibelle("Commentaire");
        pi.getFormu().getChamp("refuser").setDefaut(String.valueOf(u.getUser().getRefuser()));
        pi.getFormu().getChamp("nomUser").setDefaut(u.getUser().getNomuser());
        pi.getFormu().getChamp("refuser").setVisible(false);

        pi.preparerDataFormu();
%>

<div class="content-wrapper">
    <h1><%= titre %></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"name="<%=nomtable%>"id="<%=nomtable%>">

        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>

        <input name="acte" type="hidden" value="insert">
        <input name="bute" type="hidden" value="<%=apres%>">
        <input name="classe" type="hidden" value="<%=mapping%>">
        <input name="nomtable" type="hidden" value="<%=nomtable%>">

    </form>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
%>

<script language="JavaScript">
    alert('<%= e.getMessage() %>');
    history.back();
</script>

<%
    }
%>