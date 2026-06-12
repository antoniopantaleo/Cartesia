import GameInterface

struct CuratedLocation {
    let name: String
    let coordinates: Coordinates

    init(_ name: String, _ latitude: Double, _ longitude: Double) {
        self.name = name
        self.coordinates = Coordinates(latitude: latitude, longitude: longitude)
    }
}

/// City and town centers in countries with verified Apple LookAround coverage.
/// A coordinate without coverage is skipped at runtime by the scene retry logic.
enum CuratedLocations {
    static let all: [CuratedLocation] = [
        // United States
        CuratedLocation("New York, USA", 40.7308, -73.9973),
        CuratedLocation("Boston, USA", 42.3554, -71.0605),
        CuratedLocation("Philadelphia, USA", 39.9496, -75.1503),
        CuratedLocation("Washington DC, USA", 38.8951, -77.0364),
        CuratedLocation("Chicago, USA", 41.8857, -87.6228),
        CuratedLocation("San Francisco, USA", 37.7793, -122.4193),
        CuratedLocation("Los Angeles, USA", 34.0505, -118.2551),
        CuratedLocation("Seattle, USA", 47.6062, -122.3321),
        CuratedLocation("Portland, USA", 45.5202, -122.6742),
        CuratedLocation("Denver, USA", 39.7392, -104.9903),
        CuratedLocation("Austin, USA", 30.2672, -97.7431),
        CuratedLocation("Houston, USA", 29.7604, -95.3698),
        CuratedLocation("New Orleans, USA", 29.9584, -90.0644),
        CuratedLocation("Miami, USA", 25.7743, -80.1937),
        CuratedLocation("Atlanta, USA", 33.7490, -84.3880),
        CuratedLocation("Nashville, USA", 36.1627, -86.7816),
        CuratedLocation("Las Vegas, USA", 36.1699, -115.1398),
        CuratedLocation("San Diego, USA", 32.7157, -117.1611),
        CuratedLocation("Phoenix, USA", 33.4484, -112.0740),
        CuratedLocation("Minneapolis, USA", 44.9778, -93.2650),
        CuratedLocation("Salt Lake City, USA", 40.7608, -111.8910),
        CuratedLocation("Kansas City, USA", 39.0997, -94.5786),
        // Canada
        CuratedLocation("Toronto, Canada", 43.6532, -79.3832),
        CuratedLocation("Montreal, Canada", 45.5019, -73.5674),
        CuratedLocation("Vancouver, Canada", 49.2827, -123.1207),
        CuratedLocation("Calgary, Canada", 51.0447, -114.0719),
        CuratedLocation("Ottawa, Canada", 45.4215, -75.6972),
        CuratedLocation("Quebec City, Canada", 46.8131, -71.2075),
        // United Kingdom
        CuratedLocation("London, UK", 51.5136, -0.1365),
        CuratedLocation("Manchester, UK", 53.4808, -2.2426),
        CuratedLocation("Edinburgh, UK", 55.9533, -3.1883),
        CuratedLocation("Glasgow, UK", 55.8617, -4.2583),
        CuratedLocation("Birmingham, UK", 52.4862, -1.8904),
        CuratedLocation("Liverpool, UK", 53.4084, -2.9916),
        CuratedLocation("Bristol, UK", 51.4545, -2.5879),
        CuratedLocation("Oxford, UK", 51.7520, -1.2577),
        CuratedLocation("Cambridge, UK", 52.2053, 0.1218),
        CuratedLocation("York, UK", 53.9590, -1.0815),
        // Ireland
        CuratedLocation("Dublin, Ireland", 53.3441, -6.2675),
        CuratedLocation("Cork, Ireland", 51.8985, -8.4756),
        CuratedLocation("Galway, Ireland", 53.2707, -9.0568),
        // France
        CuratedLocation("Paris, France", 48.8666, 2.3333),
        CuratedLocation("Lyon, France", 45.7640, 4.8357),
        CuratedLocation("Marseille, France", 43.2965, 5.3698),
        CuratedLocation("Bordeaux, France", 44.8378, -0.5792),
        CuratedLocation("Toulouse, France", 43.6047, 1.4442),
        CuratedLocation("Nice, France", 43.7034, 7.2663),
        CuratedLocation("Strasbourg, France", 48.5734, 7.7521),
        CuratedLocation("Nantes, France", 47.2184, -1.5536),
        CuratedLocation("Lille, France", 50.6366, 3.0635),
        // Spain
        CuratedLocation("Madrid, Spain", 40.4168, -3.7038),
        CuratedLocation("Barcelona, Spain", 41.3874, 2.1686),
        CuratedLocation("Valencia, Spain", 39.4699, -0.3763),
        CuratedLocation("Seville, Spain", 37.3891, -5.9845),
        CuratedLocation("Bilbao, Spain", 43.2630, -2.9350),
        CuratedLocation("Granada, Spain", 37.1773, -3.5986),
        CuratedLocation("Zaragoza, Spain", 41.6488, -0.8891),
        CuratedLocation("Malaga, Spain", 36.7213, -4.4214),
        // Portugal
        CuratedLocation("Lisbon, Portugal", 38.7223, -9.1393),
        CuratedLocation("Porto, Portugal", 41.1496, -8.6109),
        CuratedLocation("Coimbra, Portugal", 40.2033, -8.4103),
        CuratedLocation("Braga, Portugal", 41.5454, -8.4265),
        // Italy
        CuratedLocation("Rome, Italy", 41.8986, 12.4769),
        CuratedLocation("Milan, Italy", 45.4642, 9.1900),
        CuratedLocation("Naples, Italy", 40.8518, 14.2681),
        CuratedLocation("Florence, Italy", 43.7696, 11.2558),
        CuratedLocation("Bologna, Italy", 44.4949, 11.3426),
        CuratedLocation("Genoa, Italy", 44.4056, 8.9463),
        CuratedLocation("Palermo, Italy", 38.1157, 13.3615),
        CuratedLocation("Verona, Italy", 45.4384, 10.9916),
        CuratedLocation("Bari, Italy", 41.1171, 16.8719),
        CuratedLocation("Catania, Italy", 37.5079, 15.0830),
        // Germany
        CuratedLocation("Berlin, Germany", 52.5170, 13.3888),
        CuratedLocation("Munich, Germany", 48.1351, 11.5820),
        CuratedLocation("Hamburg, Germany", 53.5511, 9.9937),
        CuratedLocation("Cologne, Germany", 50.9375, 6.9603),
        CuratedLocation("Frankfurt, Germany", 50.1109, 8.6821),
        CuratedLocation("Dresden, Germany", 51.0504, 13.7373),
        CuratedLocation("Stuttgart, Germany", 48.7758, 9.1829),
        CuratedLocation("Leipzig, Germany", 51.3397, 12.3731),
        // Austria
        CuratedLocation("Vienna, Austria", 48.2082, 16.3738),
        CuratedLocation("Salzburg, Austria", 47.8095, 13.0550),
        CuratedLocation("Graz, Austria", 47.0707, 15.4395),
        CuratedLocation("Innsbruck, Austria", 47.2692, 11.4041),
        // Switzerland
        CuratedLocation("Zurich, Switzerland", 47.3769, 8.5417),
        CuratedLocation("Geneva, Switzerland", 46.2044, 6.1432),
        CuratedLocation("Bern, Switzerland", 46.9480, 7.4474),
        CuratedLocation("Basel, Switzerland", 47.5596, 7.5886),
        CuratedLocation("Lucerne, Switzerland", 47.0502, 8.3093),
        // Netherlands
        CuratedLocation("Amsterdam, Netherlands", 52.3676, 4.9041),
        CuratedLocation("Rotterdam, Netherlands", 51.9244, 4.4777),
        CuratedLocation("Utrecht, Netherlands", 52.0907, 5.1214),
        CuratedLocation("The Hague, Netherlands", 52.0705, 4.3007),
        CuratedLocation("Eindhoven, Netherlands", 51.4416, 5.4697),
        // Belgium
        CuratedLocation("Brussels, Belgium", 50.8503, 4.3517),
        CuratedLocation("Antwerp, Belgium", 51.2194, 4.4025),
        CuratedLocation("Ghent, Belgium", 51.0543, 3.7174),
        CuratedLocation("Bruges, Belgium", 51.2093, 3.2247),
        // Denmark
        CuratedLocation("Copenhagen, Denmark", 55.6761, 12.5683),
        CuratedLocation("Aarhus, Denmark", 56.1629, 10.2039),
        CuratedLocation("Odense, Denmark", 55.4038, 10.4024),
        // Norway
        CuratedLocation("Oslo, Norway", 59.9139, 10.7522),
        CuratedLocation("Bergen, Norway", 60.3913, 5.3221),
        CuratedLocation("Trondheim, Norway", 63.4305, 10.3951),
        CuratedLocation("Stavanger, Norway", 58.9700, 5.7331),
        // Sweden
        CuratedLocation("Stockholm, Sweden", 59.3293, 18.0686),
        CuratedLocation("Gothenburg, Sweden", 57.7089, 11.9746),
        CuratedLocation("Malmo, Sweden", 55.6050, 13.0038),
        CuratedLocation("Uppsala, Sweden", 59.8586, 17.6389),
        // Finland
        CuratedLocation("Helsinki, Finland", 60.1699, 24.9384),
        CuratedLocation("Tampere, Finland", 61.4978, 23.7610),
        CuratedLocation("Turku, Finland", 60.4518, 22.2666),
        // Czechia
        CuratedLocation("Prague, Czechia", 50.0755, 14.4378),
        CuratedLocation("Brno, Czechia", 49.1951, 16.6068),
        CuratedLocation("Pilsen, Czechia", 49.7384, 13.3736),
        CuratedLocation("Olomouc, Czechia", 49.5938, 17.2509),
        // Croatia
        CuratedLocation("Zagreb, Croatia", 45.8150, 15.9819),
        CuratedLocation("Split, Croatia", 43.5081, 16.4402),
        CuratedLocation("Rijeka, Croatia", 45.3271, 14.4422),
        CuratedLocation("Zadar, Croatia", 44.1194, 15.2314),
        // Slovenia
        CuratedLocation("Ljubljana, Slovenia", 46.0569, 14.5058),
        CuratedLocation("Maribor, Slovenia", 46.5547, 15.6459),
        // Japan
        CuratedLocation("Tokyo (Shibuya), Japan", 35.6595, 139.7005),
        CuratedLocation("Tokyo (Asakusa), Japan", 35.7118, 139.7967),
        CuratedLocation("Osaka, Japan", 34.6937, 135.5023),
        CuratedLocation("Kyoto, Japan", 35.0116, 135.7681),
        CuratedLocation("Nagoya, Japan", 35.1815, 136.9066),
        CuratedLocation("Sapporo, Japan", 43.0618, 141.3545),
        CuratedLocation("Fukuoka, Japan", 33.5904, 130.4017),
        CuratedLocation("Hiroshima, Japan", 34.3853, 132.4553),
        CuratedLocation("Kobe, Japan", 34.6901, 135.1956),
        CuratedLocation("Yokohama, Japan", 35.4437, 139.6380),
        CuratedLocation("Sendai, Japan", 38.2682, 140.8694),
        CuratedLocation("Kanazawa, Japan", 36.5613, 136.6562),
        // Singapore
        CuratedLocation("Singapore", 1.2839, 103.8515),
        // Australia
        CuratedLocation("Sydney, Australia", -33.8688, 151.2093),
        CuratedLocation("Melbourne, Australia", -37.8136, 144.9631),
        CuratedLocation("Brisbane, Australia", -27.4698, 153.0251),
        CuratedLocation("Perth, Australia", -31.9505, 115.8605),
        CuratedLocation("Adelaide, Australia", -34.9285, 138.6007),
        CuratedLocation("Hobart, Australia", -42.8821, 147.3272),
        CuratedLocation("Canberra, Australia", -35.2809, 149.1300),
        // New Zealand
        CuratedLocation("Auckland, New Zealand", -36.8485, 174.7633),
        CuratedLocation("Wellington, New Zealand", -41.2865, 174.7762),
        CuratedLocation("Christchurch, New Zealand", -43.5321, 172.6362),
        CuratedLocation("Dunedin, New Zealand", -45.8788, 170.5028),
        // Taiwan
        CuratedLocation("Taipei, Taiwan", 25.0330, 121.5654),
        CuratedLocation("Kaohsiung, Taiwan", 22.6273, 120.3014),
        CuratedLocation("Taichung, Taiwan", 24.1477, 120.6736),
        CuratedLocation("Tainan, Taiwan", 22.9999, 120.2269),
        // Israel
        CuratedLocation("Tel Aviv, Israel", 32.0853, 34.7818),
        CuratedLocation("Jerusalem, Israel", 31.7683, 35.2137),
        CuratedLocation("Haifa, Israel", 32.7940, 34.9896),
    ]
}
