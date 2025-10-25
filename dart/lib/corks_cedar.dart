/// Celest cork credentials for Cedar-backed authorization flows.
///
/// Corks are bearer tokens inspired by Google's
/// [Macaroons](https://research.google/pubs/macaroons-cookies-with-contextual-caveats-for-decentralized-authorization-in-the-cloud/)
/// construction. They identify the entity possessing them while providing a
/// mechanism for embedding additional restrictions through
/// [Cedar](https://www.cedarpolicy.com/en) policy caveats.
library;

export 'src/cedar_cork.dart';
export 'src/cork.dart';
export 'src/exceptions.dart';
export 'src/signer.dart';
