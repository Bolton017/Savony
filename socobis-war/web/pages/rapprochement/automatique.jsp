
<%@page import="affichage.PageRecherche"%>
<%@ page import="rapprochement.AutomatiqueForm" %>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="affichage.PageInsert" %>
<%@ page import="rapprochement.ResultatRapprochement" %>

<% try{
    String dateMin = request.getParameter("dateMin");
    String dateMax = request.getParameter("dateMax");
    String idCaisseBanque = request.getParameter("idCaisseBanque");

    ClassMAPTable tc = (ClassMAPTable) (Class.forName("rapprochement.AutomatiqueForm").newInstance());
    PageInsert p = new PageInsert(tc, request);
    ClassMAPTable f = p.getObjectAvecValeur();

    AutomatiqueForm automatiqueForm = (AutomatiqueForm) f;


    System.out.println("datemin = " + dateMin);
    System.out.println("datemax = " + dateMax);
    System.out.println("idCaisse = " + idCaisseBanque);

    ResultatRapprochement t = new ResultatRapprochement();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","idSousEcriture", "idReleverDetail", "debit", "credit", "datySousEcriture", "datyReleveDetail", "designationSousEcriture","designationReleveDetail"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("rapprochement/automatique.jsp");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    ResultatRapprochement[] donnees = automatiqueForm.rappocher(null);
    pr.getTableau().setData(donnees);

    pr.getTableau().transformerDataString();

    String libEnteteAffiche[] = {"Id" , "Id &Eacute;criture", "Id Relev&eacute;", "D&eacute;bit", "Cr&eacute;dit", "Date &Eacute;criture", "Date Relev&eacute;", "D&eacute;signation &Eacute;criture", "D&eacute;signation Relev&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
//                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <form action="<%= pr.getLien() + "?but=rapprochement/apresRapprochementAuto.jsp"%>" method="post" >
            <input type="hidden" name="bute" value="rapprochement/automatique-form.jsp">
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
        </form>
    </section>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const checkboxes = document.querySelectorAll('input[type="checkbox"][name="ids"]');

        checkboxes.forEach(cb => {
            cb.checked = true;
        });
    });
</script>


<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




