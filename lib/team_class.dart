class Team {
  final String team;
  final double quota;
  final int oldCash;

  Team({this.team, this.quota, this.oldCash});

  // Math.ceil((Number(utile) + prevCash) / (quota - 1));

  result() => {
        'team': team,
        'quota': quota,
        'oldCash': oldCash,
        'cash': ((25 + oldCash) / (quota - 1)).ceil(),
        'isChecked': false,
        'isAdd': false
      };
}
