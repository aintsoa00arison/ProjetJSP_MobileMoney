<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.models.Client, mg.vola.dao.ClientDAO" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>M-Vola | Gestion des Clients</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .header-vola { background: linear-gradient(90deg, #ffcc00, #ffb300); color: #000; }
        .card { border: none; border-radius: 12px; }
        .table thead { background-color: #212529; color: white; }
        .toast-container { z-index: 1060; }
        .search-container { max-width: 400px; }
        .search-bar { border-radius: 50px !important; padding-left: 15px; background: #fff; border: 1px solid #ddd !important; }
        
        /* Style spécifique pour le Toast */
        .toast { min-width: 300px; border-radius: 10px; overflow: hidden; }
        .toast-header { border-bottom: none; padding: 12px; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="header-vola shadow-sm p-4 rounded-4 mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">👥 Gestion des Clients</h2>
            <p class="mb-0 opacity-75">Interface d'administration M-Vola</p>
        </div>
        <a href="index.jsp" class="btn btn-dark rounded-pill px-4">Accueil</a>
    </div>

    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <div class="search-container shadow-sm rounded-pill">
                <input type="text" id="searchInput" class="form-control search-bar" placeholder="Rechercher un client...">
            </div>
        </div>
        <div class="col-md-6 text-md-end mt-3 mt-md-0">
            <button class="btn btn-success shadow-sm rounded-pill px-4" type="button" data-bs-toggle="collapse" data-bs-target="#formulaireAjout">
                + Nouveau Client
            </button>
        </div>
    </div>

    <div class="collapse mb-4" id="formulaireAjout">
        <div class="card shadow-sm border-start border-4 border-success">
            <div class="card-body p-4 position-relative">
                <button type="button" class="btn-close position-absolute top-0 end-0 m-3" data-bs-toggle="collapse" data-bs-target="#formulaireAjout"></button>
                <h5 class="card-title fw-bold mb-4">Enregistrer un nouveau client</h5>
                <form action="ClientServlet" method="POST" class="row g-3" onsubmit="return validerAge('age_ajout')">
                    <input type="hidden" name="action" value="ajouter">
                    <div class="col-md-2">
                        <label class="form-label fw-semibold">Numéro Tel</label>
                        <input type="text" name="numtel" class="form-control" placeholder="034..." required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Nom Complet</label>
                        <input type="text" name="nom" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Email</label>
                        <input type="email" name="mail" class="form-control" required>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label fw-semibold">Sexe</label>
                        <select name="sexe" class="form-select">
                            <option value="M">M</option><option value="F">F</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label fw-semibold">Âge</label>
                        <input type="number" name="age" id="age_ajout" class="form-control" min="18" value="18" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-semibold">Solde (Ar)</label>
                        <input type="number" name="solde" class="form-control" value="0" min="0">
                    </div>
                    <div class="col-12 mt-4 text-end">
                        <button type="submit" class="btn btn-primary px-5 rounded-pill shadow-sm">Valider l'enregistrement</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="clientTable">
                    <thead>
                        <tr>
                            <th class="ps-4">Numéro</th>
                            <th>Nom</th>
                            <th>Email</th>
                            <th>Sexe</th>
                            <th>Âge</th>
                            <th>Solde actuel</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ClientDAO dao = new ClientDAO();
                            List<Client> clients = dao.listerClients(""); 
                            for(Client c : clients) {
                        %>
                        <tr class="align-middle client-row">
                            <td class="ps-4 fw-bold"><%= c.getNumtel() %></td>
                            <td><%= c.getNom() %></td>
                            <td><%= c.getMail() %></td>
                            <td><span class="badge rounded-pill bg-light text-dark border"><%= c.getSexe() %></span></td>
                            <td><%= c.getAge() %> ans</td>
                            <td class="text-success fw-bold"><%= String.format("%, d", c.getSolde()) %> Ar</td>
                            <td class="text-center">
                                <button class="btn btn-outline-primary btn-sm rounded-pill px-3" 
                                        onclick="ouvrirModale('<%= c.getNumtel() %>', '<%= c.getNom() %>', '<%= c.getMail() %>', '<%= c.getSexe() %>', '<%= c.getAge() %>', '<%= c.getSolde() %>')">
                                    Modifier
                                </button>
                                <form action="ClientServlet" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="supprimer">
                                    <input type="hidden" name="numtel" value="<%= c.getNumtel() %>">
                                    <button type="submit" class="btn btn-link text-danger btn-sm text-decoration-none" onclick="return confirm('Supprimer ce client ?')">Supprimer</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalModif" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <form action="ClientServlet" method="POST" class="modal-content border-0 shadow" onsubmit="return validerAge('m_age')">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold">Modifier le client <span id="displayNum"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="numtel" id="m_numtel">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-uppercase">Nom Complet</label>
                        <input type="text" name="nom" id="m_nom" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold text-uppercase">Email</label>
                        <input type="email" name="mail" id="m_mail" class="form-control" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-bold text-uppercase">Sexe</label>
                        <select name="sexe" id="m_sexe" class="form-select">
                            <option value="M">M</option><option value="F">F</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-bold text-uppercase">Âge</label>
                        <input type="number" name="age" id="m_age" class="form-control" min="18" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-bold text-uppercase">Solde (Ar)</label>
                        <input type="number" name="solde" id="m_solde" class="form-control" min="0">
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 p-3">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="submit" class="btn btn-dark rounded-pill px-4">Sauvegarder les modifications</button>
            </div>
        </form>
    </div>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="liveToast" class="toast border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div id="toastHeader" class="toast-header text-white">
            <strong class="me-auto" id="toastTitle">Statut de l'opération</strong>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body bg-white rounded-bottom" id="toastMessage"></div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
// --- LIVE SEARCH ---
document.getElementById('searchInput').addEventListener('keyup', function() {
    let filter = this.value.toLowerCase();
    document.querySelectorAll('.client-row').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(filter) ? "" : "none";
    });
});

// --- VALIDATION AGE ---
function validerAge(idChamp) {
    if (document.getElementById(idChamp).value < 18) {
        alert("Action impossible : Le client doit être majeur (18+).");
        return false;
    }
    return true;
}

// --- LOGIQUE MODALE ---
function ouvrirModale(num, nom, mail, sexe, age, solde) {
    document.getElementById('m_numtel').value = num;
    document.getElementById('displayNum').innerText = num;
    document.getElementById('m_nom').value = nom;
    document.getElementById('m_mail').value = mail;
    document.getElementById('m_sexe').value = sexe;
    document.getElementById('m_age').value = age;
    document.getElementById('m_solde').value = solde;
    new bootstrap.Modal(document.getElementById('modalModif')).show();
}

// --- GESTION DES TOASTS ---
window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    const msg = urlParams.get('msg');
    if (msg) {
        const toastEl = document.getElementById('liveToast');
        const headerEl = document.getElementById('toastHeader');
        const titleEl = document.getElementById('toastTitle');
        const bodyEl = document.getElementById('toastMessage');
        
        if (msg === 'success') {
            headerEl.classList.add('bg-success');
            titleEl.innerText = "✅ Succès de l'opération";
            bodyEl.innerText = "Les informations du client ont été mises à jour.";
        } else if (msg === 'duplicate') {
            headerEl.classList.add('bg-danger');
            titleEl.innerText = "❌ Erreur de doublon";
            bodyEl.innerText = "Ce numéro de téléphone est déjà utilisé par un autre client.";
        } else {
            headerEl.classList.add('bg-danger');
            titleEl.innerText = "❌ Erreur système";
            bodyEl.innerText = "Une erreur est survenue lors du traitement des données.";
        }
        
        new bootstrap.Toast(toastEl, { delay: 5000 }).show();
        // Nettoyer l'URL sans recharger la page
        window.history.replaceState({}, document.title, window.location.pathname);
    }
}
</script>
</body>
</html>