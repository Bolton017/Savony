<%-- 
    Document   : ouvertureCloture
    Created on : 2 août 2017, 09:30:12
    Author     : Me
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="user.UserEJB"%>
<%@page import="mg.cnaps.compta.ClotureMoisAnnee"%>
<%@page import="affichage.Liste"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="mg.cnaps.compta.ClotureMoisAnneeLib" %>
<%

    String [] val = new String[]{"","1","9"};
    String [] aff = new String[]{"Tous", "CLOTURER", "CL&Ocirc;TUR&Eacute;(E)"};

    UserEJB u = null;
    u = (UserEJB) session.getAttribute("u");
    
    ClotureMoisAnneeLib lv = new ClotureMoisAnneeLib();
    boolean verif = true;
    String user = u.getUser().getLoginuser();
    String listeCrt[] = {"mois", "annee"};
    String listeInt[] = {"mois", "annee"};
    String libEntete[] = {"moisLib", "annee","etatAction"};
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, 3);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }

    String[] valMois = {"","1","2","3","4","5","6","7","8","9","10","11","12"};
    String[] affMois = {"Tous", "Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"};
    Liste[] liste = new Liste[2];
    liste[0] = new Liste("mois1" ,affMois,valMois);
    liste[1] = new Liste("mois2" ,affMois,valMois);
    pr.getFormu().changerEnChamp(liste);

    pr.setOrdre("ORDER BY ANNEE DESC, MOIS DESC");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compta/exercice/ouvertureCloture.jsp");
    pr.getFormu().getChamp("mois1").setLibelle("Mois min");
    pr.getFormu().getChamp("mois2").setLibelle("Mois max");
    pr.getFormu().getChamp("annee1").setLibelle("Année min");
    pr.getFormu().getChamp("annee2").setLibelle("Année max");
    //pr.getFormu().getChamp("annee1").setDefaut(String.valueOf(Integer.parseInt(Utilitaire.getAnneeEnCours())-1));
    //pr.getFormu().getChamp("annee2").setDefaut(String.valueOf(Utilitaire.getAnneeEnCours()));
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libAffichage={"Mois","Année","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libAffichage);
%>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste Mois/Année</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="incident" id="incident">
            <%
               out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <% for( int i = 0; i < aff.length; i++ ){ %>
                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(val[i]) == 0) {%>
                        <option value="<%= val[i] %>" selected> <%= aff[i] %> </option>
                        <% } else { %>
                        <option value="<%= val[i] %>"> <%= aff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
                <div class="col-md-4"></div>
            </div>
        </form>
             <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
    
<script type="text/javascript">
    const divExport=document.getElementsByClassName("btn-export");
    console.log("DIV EXPORT=",divExport)
    for (let i = 0; i < divExport.length; i++) {
        divExport[i].style.display='none';
    }
</script>
