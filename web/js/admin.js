/* ===== TRACKSAFE ADMIN JS ===== */

/* ---- Sidebar toggle ---- */
function initSidebar() {
    var body = document.body;
    var stored = localStorage.getItem('adminSidebarCollapsed');
    if (stored === 'true') body.classList.add('sidebar-collapsed');

    document.querySelectorAll('.sidebar-toggle-btn, .topbar-toggle').forEach(function (btn) {
        btn.addEventListener('click', function () {
            if (window.innerWidth <= 900) {
                var sb = document.querySelector('.admin-sidebar');
                if (sb) sb.classList.toggle('mobile-open');
            } else {
                body.classList.toggle('sidebar-collapsed');
                localStorage.setItem('adminSidebarCollapsed', body.classList.contains('sidebar-collapsed'));
            }
        });
    });

    document.addEventListener('click', function (e) {
        if (window.innerWidth <= 900) {
            var sb = document.querySelector('.admin-sidebar');
            if (sb && sb.classList.contains('mobile-open') &&
                !sb.contains(e.target) && !e.target.closest('.topbar-toggle')) {
                sb.classList.remove('mobile-open');
            }
        }
    });
}

/* ---- Active nav ---- */
function setActiveNav() {
    var page = window.location.pathname.split('/').pop();
    document.querySelectorAll('.nav-item').forEach(function (item) {
        var href = (item.getAttribute('href') || '').split('/').pop();
        if (href && href !== '#' && href.toLowerCase() === page.toLowerCase()) {
            item.classList.add('active');
        }
    });
}

/* ---- Live clock ---- */
function initClock() {
    var el = document.getElementById('admin-clock');
    if (!el) return;
    function tick() {
        var now = new Date();
        var h = String(now.getHours()).padStart(2, '0');
        var m = String(now.getMinutes()).padStart(2, '0');
        var s = String(now.getSeconds()).padStart(2, '0');
        el.textContent = h + ':' + m + ':' + s;
    }
    tick();
    setInterval(tick, 1000);
}

/* ---- Toast ---- */
function showToast(message, type) {
    var old = document.querySelector('.ts-toast');
    if (old) old.remove();
    var t = document.createElement('div');
    t.className = 'ts-toast ' + (type || 'success');
    var icon = type === 'error' ? '✕' : type === 'warning' ? '⚠' : '✓';
    t.innerHTML = '<span style="font-weight:900;font-size:1rem;">' + icon + '</span> ' + message;
    document.body.appendChild(t);
    setTimeout(function () {
        t.style.cssText += 'opacity:0;transition:opacity 0.4s;';
        setTimeout(function () { t.remove(); }, 400);
    }, 3800);
}

/* ---- Confirm send link ---- */
function Send_Link(id, fromMail, aadhar_no) {
    var ok = confirm('Send the decryption key link to ' + fromMail + '?\n\nAadhaar: ' + aadhar_no);
    if (ok) {
        window.location.href = 'Send_Link?M_Id=' + id +
            '&FromMail=' + encodeURIComponent(fromMail) +
            '&aadhar_no=' + encodeURIComponent(aadhar_no);
    }
}

/* ---- Scroll reveal ---- */
function initReveal() {
    if (!window.IntersectionObserver) return;
    var obs = new IntersectionObserver(function (entries) {
        entries.forEach(function (e) {
            if (e.isIntersecting) {
                e.target.style.opacity = '1';
                e.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.07 });
    document.querySelectorAll('.stat-card, .ip-location-card, .mail-request-card, .group-item').forEach(function (el) {
        el.style.opacity = '0';
        el.style.transform = 'translateY(16px)';
        el.style.transition = 'opacity 0.45s ease, transform 0.45s ease';
        obs.observe(el);
    });
}

/* ---- IP validation for add form ---- */
function validateIP(ip) {
    var parts = ip.split('.');
    if (parts.length !== 4) return false;
    return parts.every(function (p) {
        var n = parseInt(p, 10);
        return !isNaN(n) && n >= 0 && n <= 255 && String(n) === p;
    });
}

document.addEventListener('DOMContentLoaded', function () {
    initSidebar();
    setActiveNav();
    initClock();
    setTimeout(initReveal, 80);

    /* IP field inline validation */
    document.querySelectorAll('input[name="ipAddress"]').forEach(function (inp) {
        inp.addEventListener('blur', function () {
            if (inp.value && !validateIP(inp.value.trim())) {
                inp.style.borderColor = '#ef4444';
                inp.style.boxShadow = '0 0 0 3px rgba(239,68,68,0.15)';
                showToast('Invalid IP address format.', 'error');
            } else {
                inp.style.borderColor = '';
                inp.style.boxShadow = '';
            }
        });
    });
});