
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="rapprochement.AutomatiqueForm" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String nomtable = "CLIENT",
                titre = "Rapprochement";


        AutomatiqueForm client = new AutomatiqueForm();
        PageInsert pi = new PageInsert(client, request, u);
        pi.setLien((String) session.getValue("lien"));


        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet liste1 = new TypeObjet();
        liste1.setNomTable("caissebanque");
        liste[0] = new Liste("idCaisseBanque", liste1, "val", "id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("idCaisseBanque").setLibelle("Banque");
        pi.getFormu().getChamp("dateMin").setLibelle("Date min");
        pi.getFormu().getChamp("dateMax").setLibelle("Date max");
//        pi.getFormu().getChamp("dateMin").setType("date");
//        pi.getFormu().getChamp("dateMax").setType("date");


        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=rapprochement/automatique.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
    </form>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const button = document.querySelector('button[type="submit"][name="Submit2"]');
        button.textContent = "Rapprocher";
    });
</script>


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
