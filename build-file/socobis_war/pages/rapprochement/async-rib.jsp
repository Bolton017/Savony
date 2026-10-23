<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="mg.cnaps.compta.ComptaSousEcriture" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.PageRechercheChoix" %>
<%@ page import="rapprochement.ReleverDetail" %>
<%@ page import="rapprochement.ReleverDetailCpl" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="utilitaire.Utilitaire" %>

<style>
.table-recap {
    width: 100%;
    border-collapse: collapse;
    font-family: Arial, sans-serif;
    background: #ffffff;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    border-radius: 8px;
    overflow: hidden;
}

.table-recap th {
    background: #f5f7fa;
    color: #333;
    text-align: left;
    padding: 12px;
    font-weight: 600;
    border-bottom: 1px solid #e0e0e0;
}

.table-recap td {
    padding: 12px;
    border-bottom: 1px solid #eaeaea;
    color: #444;
}

.table-recap tr:last-child td {
    border-bottom: none;
}

</style>


<% try{ 
    ComptaSousEcriture o = new ComptaSousEcriture();
    o.setNomTable("SOUSECRITURENRMVT");
    String[] listeCrt = {"compte","mouvement","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","libellePiece","daty","debit","credit"};
    PageRechercheChoix pr = new PageRechercheChoix(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length,true);
    pr.setPreciserChoix(false);
    System.out.println(pr.getPremier());
    pr.setTitre("Rapprochement bancaire &Eacute;criture - Relev&eacute;s");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("rapprochement/async-rib.jsp");
    pr.getFormu().getChamp("compte").setLibelle("Banque");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

    Liste[] liste=new Liste[2];
    TypeObjet typeContrat = new TypeObjet();
    typeContrat.setNomTable("BANQUE_COMPTA");
    liste[0]=new Liste("compte",typeContrat,"val","desce");
    liste[0].setLibelle("Banque");
    String[] mouvementVals = {"%","1","2"};
    String[] mouvementLibs = {"Tous","D&eacute;bit","Cr&eacute;dit"};
    liste[1]=new Liste("mouvement",mouvementLibs,mouvementVals);
    //liste[1].setDefaut("1");
    pr.getFormu().changerEnChamp(liste);
    pr.setPremier(false);
    String actionForm = "rapprochement/apresRapprochement.jsp";
    String principal = "ECRITURE";
    String[] ids = request.getParameterValues("ids_selection");
    if (ids == null || ids.length == 0) {
        ids = (String[]) session.getAttribute("ids");
    }
    session.removeAttribute("ids");

    ReleverDetailCpl[] res = null;
    double sommeAutre = 0;
    String colMontant = "5"; // Numéro de colonne sur l'affichage (4 débit)
    if(ids!=null && ids.length>0) {
        res = ReleverDetail.getReleveDetail(ids);
        if(res.length>0){
            pr.getFormu().getChamp("compte").setDefaut(res[0].getCompte());
            double credit = AdminGen.calculSommeDouble(res,"credit");
            double debit = AdminGen.calculSommeDouble(res,"debit");
            sommeAutre = debit;
            if (debit == 0) {
                colMontant = "4"; // (5 col Crédit)
                sommeAutre = credit;
            }
            pr.setAWhere(" AND COMPTE='"+res[0].getCompte()+"' AND DEBIT<="+credit+" AND CREDIT<="+debit+" AND DATY<= DATE '"+res[0].getDatyvaleur()+"'");
            pr.setPremier(false);
        }
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    ComptaSousEcriture [] data = (ComptaSousEcriture[]) pr.getTableau().getData();
    int size = data.length;
    double creditData = AdminGen.calculSommeDouble(data,"credit");
    double debitData = AdminGen.calculSommeDouble(data,"debit");
            
   // System.out.println("==================================="+creditData);
   // System.out.println("==================================="+debitData);

    String[] libEnteteAffiche = {"Id","Libell&eacute; de la pi&egrave;ce","Date","D&eacute;bit","Cr&eacute;dit"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);


%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <%
                if (ids != null) {
                    for (String id : ids) {
            %>
            <input name="ids_selection" type="hidden" value="<%= id %>">
            <%
                    }
                }
            %>
            <input name="premier" type="hidden"  value="false">
        </form>
        <br>
        <%
            //out.println(pr.getTableauRecap().getHtml());
            out.println("<table class='table-recap'>");

            out.println("<tr>");
            out.println("<th>Nombre</th>");
            out.println("<th>Somme des débits non rapprochés</th>");
            out.println("<th>Somme des crédits non rapprochés</th>");
            out.println("</tr>");

            out.println("<tr>");
            out.println("<td class='Nombre'>" +  size + "</td>");
            out.println("<td class='valeur debit'>" +  utilitaire.Utilitaire.formaterAr(debitData) + " Ar</td>");
            out.println("<td class='valeur credit'>" + utilitaire.Utilitaire.formaterAr(creditData) + " Ar</td>");
            out.println("</tr>");

            out.println("</table>");

        %>
        <% if(res!=null && res.length>0) { %>
        <br/>
        <div class="row">
            <div class="col-md-4"  >
                <label>Total Relev&eacute;s</label>
                <input class="form-control montant" id="total1" name="total1" readonly value="<%=sommeAutre%>" type="text">
            </div>
            <div class="col-md-4">
                <label for="total2" class="input-label">Total &Eacute;critures</label>
                <input class="form-control montant" id="total2" name="total2" readonly value="0" type="text">
            </div>
            <div class="col-md-4">
                <label class="input-label" for="ecart" >Ecart</label>
                <input class="form-control" id="ecart" name="ecart" type="text" readonly value="0" readonly>
            </div>
        </div>
        <br/>

        <br>
        <div class="box table-container" style="margin-top: 40px !important;">
            <div class="box-body table-responsive no-padding">
                <div id="selectnonee">
                    <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3"
                           class="table table-hover table-striped" style="font-size: 14px;">
                        <thead>
                        <tr class="head">
                            <th width="20%" align="center" valign="top" class="contenuetable"><a
                                    href="module.jsp?but=rapprochement/async-rib.jsp&amp;numPag=1&amp;compte=512110&amp;daty1=&amp;daty2=&amp;colonne=id&amp;ordre=-&amp;colAffiche1=id&amp;colAffiche2=libellePiece&amp;colAffiche3=daty&amp;colAffiche4=debit&amp;colAffiche5=credit&amp;triCol=yes&amp;newcol=id">Id</a>
                            </th>
                            <th width="20%" align="center" valign="top" class="contenuetable"><a
                                    href="module.jsp?but=rapprochement/async-rib.jsp&amp;numPag=1&amp;compte=512110&amp;daty1=&amp;daty2=&amp;colonne=id&amp;ordre=-&amp;colAffiche1=id&amp;colAffiche2=libellePiece&amp;colAffiche3=daty&amp;colAffiche4=debit&amp;colAffiche5=credit&amp;triCol=yes&amp;newcol=libellePiece">Libellé
                                de la pièce</a></th>
                            <th width="20%" align="center" valign="top" class="contenuetable"><a
                                    href="module.jsp?but=rapprochement/async-rib.jsp&amp;numPag=1&amp;compte=512110&amp;daty1=&amp;daty2=&amp;colonne=id&amp;ordre=-&amp;colAffiche1=id&amp;colAffiche2=libellePiece&amp;colAffiche3=daty&amp;colAffiche4=debit&amp;colAffiche5=credit&amp;triCol=yes&amp;newcol=daty">Date</a>
                            </th>
                            <th width="20%" align="center" valign="top" class="contenuetable"><a
                                    href="module.jsp?but=rapprochement/async-rib.jsp&amp;numPag=1&amp;compte=512110&amp;daty1=&amp;daty2=&amp;colonne=id&amp;ordre=-&amp;colAffiche1=id&amp;colAffiche2=libellePiece&amp;colAffiche3=daty&amp;colAffiche4=debit&amp;colAffiche5=credit&amp;triCol=yes&amp;newcol=debit">Débit</a>
                            </th>
                            <th width="20%" align="center" valign="top" class="contenuetable"><a
                                    href="module.jsp?but=rapprochement/async-rib.jsp&amp;numPag=1&amp;compte=512110&amp;daty1=&amp;daty2=&amp;colonne=id&amp;ordre=-&amp;colAffiche1=id&amp;colAffiche2=libellePiece&amp;colAffiche3=daty&amp;colAffiche4=debit&amp;colAffiche5=credit&amp;triCol=yes&amp;newcol=credit">Crédit</a>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (int i = 0; i < res.length; i++) { %>
                            <tr onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor=''" style="">
                                <td width="20%" align="left"><%= res[i].getId()%></td>
                                <td width="20%" align="left"><%= res[i].getDesignation()%></td>
                                <td width="20%" align="left"><%= res[i].getDatyvaleur()%></td>
                                <td width="20%" align="left"><%= res[i].getDebit()%></td>
                                <td width="20%" align="left"><%= res[i].getCredit()%></td>
                            </tr>
                        <% } %>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <% } %>
        <br>
        <% if (!pr.getPremier()) {%>
        <form action="<%= pr.getLien()+"?but="+actionForm%>" method="post">
            <input type="hidden" value="<%=pr.getLien()%>" name="lien">
            <% if (ids != null) {
                for (String id : ids) { %>
                    <input type="hidden" name="ids2" value="<%= id %>">
            <%  } } %>
            <input type="hidden" value="<%=principal%>" name="principal">
            <input type="hidden" value="rapprochement/rib-async.jsp" name="bute">
            <input type="hidden" value="<%=colMontant%>" name="col_montant" id="col_montant">
            <%
                pr.getTableau().setNameBoutton("Rapprocher");
                ComptaSousEcriture[] dataTable = (ComptaSousEcriture[]) pr.getTableau().getData();
                if (dataTable == null || dataTable.length == 0) {
                    out.println("<div class='text-center' style='padding: 20px; font-style: italic;'>Aucune &eacute;criture ne correspond &agrave; votre recherche.</div>");
                } else {
                    out.println(pr.getTableau().getHtmlWithCheckbox());
                    out.println(pr.getBasPage());
                }
            %>
        </form>
        <% } %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        function parseMontant(text) {
            if (!text) return 0;
            return parseFloat(
                text.replace(/\u00a0/g, '')
                    .replace(/\s/g, '')
            ) || 0;
        }

        window.recalculerTotaux = function () {
            const COL_MONTANT = document.getElementById("col_montant").value;

            let totalMontant = 0;

            document.querySelectorAll('input[type="checkbox"][name="ids"]:checked')
                .forEach(cb => {
                    const tr = cb.closest("tr");
                    const tds = tr.querySelectorAll("td");
                    const montant  = tds[COL_MONTANT]?.innerText || "0";
                    totalMontant += parseMontant(montant);
                });

            const total1 = document.getElementById("total1").value;
            const ecart = total1 - totalMontant;

            document.getElementById("total2").value = totalMontant.toLocaleString('fr-FR');
            document.getElementById("ecart").value = ecart.toLocaleString('fr-FR');
        };

        document.addEventListener("change", function (e) {
            if (e.target.matches('input[type="checkbox"][name="ids"]')) {
                recalculerTotaux();
            }
        });

        window.onload = function() {
            recalculerTotaux();
        };

        if (typeof window.CocheToutCheckbox === "function") {
            const originalCocheTout = window.CocheToutCheckbox;

            window.CocheToutCheckbox = function () {
                originalCocheTout.apply(this, arguments);
                recalculerTotaux();
            };
        }

    });
</script>


