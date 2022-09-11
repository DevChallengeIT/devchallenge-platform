const dayInMsec = 1000 * 60 * 60 * 24;
const hourInMsec = 1000 * 60 * 60;
const minuteInMsec = 1000 * 60;

function updateTimer(id, millisecondsLeft) {
  const msecLeft = millisecondsLeft < 1000 ? 0 : millisecondsLeft;

  // Time calculations for days, hours, minutes and seconds
  const days = Math.floor(msecLeft / dayInMsec);
  const hours = Math.floor((msecLeft % dayInMsec) / hourInMsec);
  const minutes = Math.floor((msecLeft % hourInMsec) / minuteInMsec);
  const seconds = Math.floor((msecLeft % minuteInMsec) / 1000);

  document.getElementById(id).innerHTML = days + "d " + hours + "h " + minutes + "m " + seconds + "s";
}

function initializeTimer(id, initialMsecLeft) {
  let msecLeft = initialMsecLeft;
  updateTimer(id, msecLeft);

  const x = setInterval(() => {
    updateTimer(id, msecLeft -= 1000);

    if (msecLeft < 1000) {
      clearInterval(x);
    }
  }, 1000);
}

window.initializeTimer = initializeTimer;
