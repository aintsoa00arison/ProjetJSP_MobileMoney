<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.dao.FraisDAO, mg.vola.models.FraisEnvoi, mg.vola.models.FraisRecep" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Grille Tarifaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --accent-rose: #F43F5E;
            --bg-page: #F1F5F9;
            --soft-radius: 12px;
            --border-color: #E2E8F0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page);
            color: var(--main-dark);
        }

        .header-card {
            background: white;
            border-left: 6px solid var(--accent-mint);
            border-radius: var(--soft-radius);
        }

        .form-card {
            background: white;
            border-radius: var(--soft-radius);
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
            overflow: hidden;
        }

        .form-card-header {
            background: var(--main-dark);
            padding: 16px 24px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dashboard-container {
            background: white;
            border-radius: var(--soft-radius);
            border: 1px solid var(--border-color);
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
        }

        /* --- DASHBOARD SWITCHER CORRIGÉ --- */
        .nav-section-switcher {
            display: flex;
            background: #CBD5E1; 
            padding: 6px;
            border-bottom: 1px solid var(--border-color);
        }

        .nav-section-switcher .nav-link {
            flex: 1;
            text-align: center;
            padding: 14px 20px;
            color: var(--main-dark) !important;
            font-weight: 700;
            border: none;
            border-radius: 10px;
            transition: all 0.25s ease;
            background: transparent;
            opacity: 1;
        }

        .nav-section-switcher .nav-link i { color: var(--main-dark); }

        .nav-section-switcher .nav-link:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.4);
        }

        .nav-section-switcher .nav-link.active {
            background: white;
            color: var(--main-dark) !important;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.1);
        }

        .nav-link[data-bs-target="#tab-envoi"].active i { color: var(--accent-mint); }
        .nav-link[data-bs-target="#tab-recep"].active i { color: var(--accent-rose); }

        .form-label { font-size: 0.82rem; font-weight: 600; color: #64748B; margin-bottom: 6px; }

        .form-control, .form-select {
            border-radius: var(--soft-radius);
            padding: 10px 16px;
            border: 1px solid var(--border-color);
            background-color: #F8FAFC;
            transition: all 0.2s;
            font-size: 0.9rem;
        }
        .form-control:focus, .form-select:focus {
            background-color: #fff;
            border-color: var(--accent-mint);
            box-shadow: 0 0 0 4px rgba(45, 212, 191, 0.1);
        }

        .table-vola thead th {
            background-color: transparent;
            color: #64748B;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 14px 20px;
            border-bottom: 2px solid var(--border-color);
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .table-vola tbody td {
            padding: 16px 20px;
            border-bottom: 1px solid #F1F5F9;
            vertical-align: middle;
            font-size: 0.9rem;
            color: #334155;
        }

        .frais-row {
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .frais-row:hover {
            background-color: #F8FAFC;
            border-left: 3px solid var(--accent-mint);
        }

        .tranche-label { font-size: 0.88rem; color: #475569; }
        .tranche-label b { color: var(--main-dark); font-weight: 700; }

        .price-badge {
            display: inline-block;
            background: #DCFCE7;
            color: #065F46;
            font-weight: 700;
            font-size: 0.85rem;
            padding: 5px 12px;
            border-radius: 8px;
        }

        .btn-edit {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background: white;
            color: var(--main-dark);
            transition: all 0.2s;
        }
        .btn-edit:hover { background: var(--main-dark); color: white; border-color: var(--main-dark); }

        .btn-delete {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 8px;
            border: 1px solid #FEE2E2;
            background: #FEF2F2;
            color: #DC2626;
            transition: all 0.2s;
            text-decoration: none;
        }
        .btn-delete:hover { background: #DC2626; color: white; border-color: #DC2626; }

        .btn-action {
            border-radius: var(--soft-radius);
            padding: 12px 24px;
            font-weight: 600;
            transition: 0.3s;
            border: none;
        }
        .btn-mint { background: var(--accent-mint); color: var(--main-dark); }
        .btn-mint:hover { background: #24b8a5; transform: translateY(-2px); color: var(--main-dark); }

        .search-wrap { position: relative; }
        .search-wrap .bi {
            position: absolute; left: 16px; top: 50%;
            transform: translateY(-50%); color: #94A3B8;
            font-size: 1rem; pointer-events: none;
        }
        .search-wrap input {
            padding-left: 44px;
            border-radius: var(--soft-radius) !important;
            border: 1px solid var(--border-color) !important;
            background: white; height: 46px; transition: all 0.2s;
        }
        .search-wrap input:focus {
            border-color: var(--accent-mint) !important;
            box-shadow: 0 0 0 4px rgba(45, 212, 191, 0.1) !important;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">

    <!-- === HEADER === -->
    <div class="header-card shadow-sm p-4 mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">Grille Tarifaire</h2>
            <p class="mb-0 text-muted">Configuration des commissions d'envoi et de retrait</p>
        </div>
        <button class="btn btn-dark px-4 py-2 fw-bold" style="border-radius: 10px;"
                data-bs-toggle="collapse" data-bs-target="#formFrais">
            <i class="bi bi-plus-circle me-2"></i>Nouvelle tranche
        </button>
    </div>

    <!-- === FORMULAIRE AJOUT === -->
    <div class="collapse mb-4" id="formFrais">
        <div class="form-card">
            <div class="form-card-header">
                <span class="fw-bold fs-6">Nouvelle règle tarifaire</span>
                <button type="button" class="btn-close btn-close-white btn-sm"
                        data-bs-toggle="collapse" data-bs-target="#formFrais"></button>
            </div>
            <div class="p-4">
                <form action="FraisServlet" method="POST" class="row g-3">
                    <input type="hidden" name="action" value="ajouter">
                    <div class="col-md-2">
                        <label class="form-label">Type de flux</label>
                        <select name="type_frais" class="form-select">
                            <option value="ENVOI">Frais d'envoi</option>
                            <option value="RECEP">Frais de retrait</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Montant minimum (Ar)</label>
                        <input type="number" name="montant1" class="form-control" placeholder="0" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Montant maximum (Ar)</label>
                        <input type="number" name="montant2" class="form-control" placeholder="0" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Frais appliqués (Ar)</label>
                        <input type="number" name="valeur" class="form-control" placeholder="0" required>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-mint btn-action w-100 shadow-sm">
                            <i class="bi bi-check2-circle me-1"></i>Enregistrer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- === BARRE RECHERCHE === -->
    <div class="mb-3">
        <div class="search-wrap" style="max-width: 420px;">
            <i class="bi bi-search"></i>
            <input type="text" id="searchFrais" placeholder="Rechercher une tranche tarifaire...">
        </div>
    </div>

    <!-- === TABLEAU AVEC ONGLETS === -->
    <div class="dashboard-container">

        <nav class="nav nav-section-switcher" role="tablist">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-envoi" type="button">
                <i class="bi bi-send-fill me-2"></i>Frais d'envoi
            </button>
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-recep" type="button">
                <i class="bi bi-wallet2 me-2"></i>Frais de retrait
            </button>
        </nav>

        <div class="tab-content p-4">
            <% FraisDAO dao = new FraisDAO(); %>

            <!-- Frais d'envoi -->
            <div class="tab-pane fade show active" id="tab-envoi">
                <div class="table-responsive">
                    <table class="table table-vola mb-0">
                        <thead>
                            <tr>
                                <th>Tranche de montant</th>
                                <th>Commission</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<FraisEnvoi> listeEnv = dao.listerFraisEnv();
                                for (FraisEnvoi e : listeEnv) {
                            %>
                            <tr class="frais-row">
                                <td>
                                    <span class="tranche-label">
                                        De <b><%= String.format("%,d", e.getMontant1()) %> Ar</b>
                                        à <b><%= String.format("%,d", e.getMontant2()) %> Ar</b>
                                    </span>
                                </td>
                                <td><span class="price-badge"><%= String.format("%,d", e.getFrais_env()) %> Ar</span></td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-2">
                                        <button class="btn-edit"
                                            onclick="ouvrirModale('ENVOI','<%= e.getIdEnv() %>','<%= e.getMontant1() %>','<%= e.getMontant2() %>','<%= e.getFrais_env() %>')">
                                            <i class="bi bi-pencil me-1"></i>Éditer
                                        </button>
                                        <form action="FraisServlet" method="POST" class="d-inline m-0">
                                            <input type="hidden" name="action" value="supprimer">
                                            <input type="hidden" name="type_frais" value="ENVOI">
                                            <input type="hidden" name="id" value="<%= e.getIdEnv() %>">
                                            <button type="submit" class="btn-delete"
                                                    onclick="return confirm('Supprimer cette règle ?')">
                                                <i class="bi bi-trash me-1"></i>Supprimer
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Frais de retrait -->
            <div class="tab-pane fade" id="tab-recep">
                <div class="table-responsive">
                    <table class="table table-vola mb-0">
                        <thead>
                            <tr>
                                <th>Tranche de montant</th>
                                <th>Commission</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<FraisRecep> listeRec = dao.listerFraisRec();
                                for (FraisRecep r : listeRec) {
                            %>
                            <tr class="frais-row">
                                <td>
                                    <span class="tranche-label">
                                        De <b><%= String.format("%,d", r.getMontant1()) %> Ar</b>
                                        à <b><%= String.format("%,d", r.getMontant2()) %> Ar</b>
                                    </span>
                                </td>
                                <td><span class="price-badge"><%= String.format("%,d", r.getFrais_rec()) %> Ar</span></td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-2">
                                        <button class="btn-edit"
                                            onclick="ouvrirModale('RECEP','<%= r.getIdRec() %>','<%= r.getMontant1() %>','<%= r.getMontant2() %>','<%= r.getFrais_rec() %>')">
                                            <i class="bi bi-pencil me-1"></i>Éditer
                                        </button>
                                        <form action="FraisServlet" method="POST" class="d-inline m-0">
                                            <input type="hidden" name="action" value="supprimer">
                                            <input type="hidden" name="type_frais" value="RECEP">
                                            <input type="hidden" name="id" value="<%= r.getIdRec() %>">
                                            <button type="submit" class="btn-delete"
                                                    onclick="return confirm('Supprimer cette règle ?')">
                                                <i class="bi bi-trash me-1"></i>Supprimer
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- ===== MODAL MODIFICATION ===== -->
<div class="modal fade" id="modalFrais" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form action="FraisServlet" method="POST" class="modal-content border-0 shadow-lg"
              style="border-radius: 16px; overflow: hidden;">
            <div class="modal-header border-0 p-4" style="background: var(--main-dark);">
                <h5 class="modal-title fw-bold text-white">
                    <i class="bi bi-pencil-square me-2"></i>Modifier la règle tarifaire
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="type_frais" id="m_type">
                <input type="hidden" name="id" id="m_id">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Montant minimum (Ar)</label>
                        <input type="number" name="montant1" id="m_m1" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Montant maximum (Ar)</label>
                        <input type="number" name="montant2" id="m_m2" class="form-control" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Frais appliqués (Ar)</label>
                        <input type="number" name="valeur" id="m_val" class="form-control form-control-lg fw-bold" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 p-4 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="submit" class="btn btn-mint btn-action px-4 shadow-sm">
                    <i class="bi bi-check2-circle me-2"></i>Sauvegarder
                </button>
            </div>
        </form>
    </div>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
    <div id="liveToast" class="toast align-items-center text-white border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold" id="toastMsg"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showNotify(message, type) {
        const toastEl = document.getElementById('liveToast');
        document.getElementById('toastMsg').innerText = message;
        toastEl.className = 'toast align-items-center text-white border-0 shadow-lg bg-' + (type === 'success' ? 'success' : 'danger');
        bootstrap.Toast.getOrCreateInstance(toastEl).show();
    }

    document.getElementById('searchFrais').addEventListener('keyup', function () {
        const val = this.value.toLowerCase();
        document.querySelectorAll('.frais-row').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(val) ? '' : 'none';
        });
    });

    function ouvrirModale(type, id, m1, m2, val) {
        document.getElementById('m_type').value = type;
        document.getElementById('m_id').value   = id;
        document.getElementById('m_m1').value   = m1;
        document.getElementById('m_m2').value   = m2;
        document.getElementById('m_val').value  = val;
        bootstrap.Modal.getOrCreateInstance(document.getElementById('modalFrais')).show();
    }

    window.onload = () => {
        const params = new URLSearchParams(window.location.search);
        if (params.get('msg') === 'added')      showNotify('Plage de frais ajoutée avec succès !', 'success');
        if (params.get('msg') === 'duplicated') showNotify('Cette plage existe déjà !', 'error');
        if (params.get('msg') === 'updated')    showNotify('Plage de frais mise à jour avec succès !', 'success');
        if (params.get('msg') === 'deleted')    showNotify('Plage de frais supprimée.', 'success');
        if (params.get('msg') === 'error')      showNotify('Une erreur technique est survenue.', 'error');
        window.history.replaceState({}, '', window.location.pathname);
    };
</script>
</body>
</html>