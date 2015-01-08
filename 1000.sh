echo "result, time, p1 fielding, p1 bowling, p1 batting, p2 fielding, p2 bowling, p2 battubg, p1 wickets, p1 runs, p1 overs, p2 wickets, p2 runs, p2 overs, dot, 1, 2, 3, 4, 5, 6, w, nb, run rate, dot, 1, 2, 3, 4, 5, 6, w, nb, run rate" >> results.csv
for ((i=1;i<=1000;i++));
do
  `balance.sh`
done
