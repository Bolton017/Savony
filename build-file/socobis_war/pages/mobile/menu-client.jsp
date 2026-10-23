<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% try{
    String lien = (String) session.getAttribute("lien");
    String idClient = request.getParameter("idClient");
%>
<div class="content-wrapper">
    <jsp:include page="/pages/elements/headerMobile.jsp">
        <jsp:param name="titre" value="Menu client"/>
    </jsp:include>
    <div class="search-result-container">
        <div class="search-result__box ">
            <i class="material-symbols-rounded">shopping_cart</i>
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">Prise de commande</h3>
            </div>
            <a href="<%= lien + "?but=mobile/commande-client.jsp&idClient="+idClient%>" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
        <div class="search-result__box ">
            <i class="material-symbols-rounded">attach_money</i>
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">Recouvrement</h3>
            </div>
            <a href="<%= lien + "?but=mobile/menu-recouvrement.jsp&idClient="+idClient%>" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
        <div class="search-result__box ">
            <i class="material-symbols-rounded">directions_walk</i>
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">Visite</h3>
            </div>
            <a href="<%= lien + "?but=mobile/liste-visite.jsp&idClient="+idClient%>" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
        <div class="search-result__box ">
            <i class="material-symbols-rounded">mystery</i>
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">Veille concurentielle</h3>
            </div>
            <a href="<%= lien + "?but=mobile/liste-veille-concurentielle.jsp&idClient="+idClient%>" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
        <div class="search-result__box ">
            <i class="material-symbols-rounded">quiz</i>
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">Sondage concurentielle</h3>
            </div>
            <a href="#" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
    </div>


</div>
<% } catch (Exception e) {
    e.printStackTrace(); %>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
    </script>
<% }%>