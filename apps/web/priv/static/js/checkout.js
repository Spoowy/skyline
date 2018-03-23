function create(htmlStr) {
    var frag = document.createDocumentFragment(),
        temp = document.createElement('div');
    temp.innerHTML = htmlStr;
    while (temp.firstChild) {
        frag.appendChild(temp.firstChild);
    }
    return frag;
}

function startTimer(duration, display) {
    var start = Date.now(),
        diff,
        minutes,
        seconds;
    function timer() {
        diff = duration - (((Date.now() - start) / 1000) | 0);

        minutes = (diff / 60) | 0;
        seconds = (diff % 60) | 0;

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.textContent = minutes + ":" + seconds;

        if (diff <= 0) {
            start = Date.now() + 1000;
        }
    };
    timer();
    setInterval(timer, 1000);
}

window.onload = function () {

    var fragment3 = create('<div style="background:#fff5d2;padding:10px 20px;border:1px solid #e3df74; font-size:14px; color:#2c2c2c; font-weight:bold;-webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; margin:10px 0px 10px 0px">Ihre Bestellung ist für <span id="time"></span> Minuten reserviert!</div>');
    document.getElementsByClassName('main__header')[0].appendChild(fragment3);

    var ten = 60 * 8.9,
        display = document.querySelector('#time');
    startTimer(ten, display);
};