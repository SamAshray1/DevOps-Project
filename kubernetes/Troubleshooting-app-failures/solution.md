## Solution to the app failures

1. In vote-svc.yml
change port to 80, instead of 8080

2. In netpol.yml
    - podSelector:
        matchLabels:
          app: "vote"

3. In result-svc.yml
changed     app: results
to result, which matches the name in deploy.yml