defmodule Journette.Blog do
  @moduledoc """
  Placeholder blog context. Functions return hardcoded seed data now;
  swap each function body for real DB queries when the Posts schema is built.
  """

  @articles [
    %{
      id: 1,
      title: "Global Leaders Convene for Historic Climate Summit as Critical Deadlines Approach",
      excerpt:
        "World leaders gathered in Geneva this week to confront the accelerating climate crisis, with scientists warning that immediate coordinated action is now the only path to preventing irreversible damage to ecosystems across three continents.",
      category: "World",
      tag: "FEATURED",
      author: "Sarah Mitchell",
      author_initials: "SM",
      published_at: "Apr 25, 2026",
      reading_time: 5,
      featured: true,
      bg: "linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)"
    },
    %{
      id: 2,
      title: "Central Bank Raises Rates for Third Consecutive Quarter Amid Stubbornly High Inflation",
      excerpt:
        "The Federal Reserve has signalled another rate hike as consumer prices continue to outpace forecasts, rattling bond markets globally and raising fears of a prolonged squeeze on household budgets.",
      category: "Business",
      tag: "ECONOMY",
      author: "James Okafor",
      author_initials: "JO",
      published_at: "Apr 25, 2026",
      reading_time: 4,
      featured: false,
      bg: "linear-gradient(135deg, #1a0a00 0%, #3d1a00 50%, #5c2a00 100%)"
    },
    %{
      id: 3,
      title: "Breakthrough AI Model Passes Medical Licensing Exam with Near-Perfect Score",
      excerpt:
        "A new large language model trained specifically on clinical data has outperformed most human candidates in the standardised medical board examination, reigniting debate about AI's role in healthcare.",
      category: "Technology",
      tag: "AI",
      author: "Priya Sharma",
      author_initials: "PS",
      published_at: "Apr 24, 2026",
      reading_time: 6,
      featured: false,
      bg: "linear-gradient(135deg, #0a192f 0%, #0d2137 50%, #112240 100%)"
    },
    %{
      id: 4,
      title: "Champions League Final Set to Shatter Attendance Records in New Mega-Stadium",
      excerpt:
        "Europe's biggest football showdown is heading to a 100,000-capacity venue, with tickets selling out in under six minutes across the continent.",
      category: "Sports",
      tag: "FOOTBALL",
      author: "Carlos Vega",
      author_initials: "CV",
      published_at: "Apr 24, 2026",
      reading_time: 3,
      featured: false,
      bg: "linear-gradient(135deg, #052e16 0%, #064e3b 50%, #065f46 100%)"
    },
    %{
      id: 5,
      title: "Cities Worldwide Embrace 4-Day Work Week as Pilots Exceed Productivity Expectations",
      excerpt:
        "A landmark study spanning 60 companies and 4,500 workers found no productivity loss — and significant gains in employee well-being, retention, and creativity.",
      category: "Business",
      tag: "FUTURE OF WORK",
      author: "Amara Diallo",
      author_initials: "AD",
      published_at: "Apr 23, 2026",
      reading_time: 7,
      featured: false,
      bg: "linear-gradient(135deg, #1c1917 0%, #292524 50%, #3d3a37 100%)"
    },
    %{
      id: 6,
      title: "Scientists Uncover Dozen New Deep-Sea Species in Unexplored Pacific Trench",
      excerpt:
        "A remotely operated submersible deployed at record depths captured footage of at least twelve previously unknown marine creatures, including a bioluminescent eel never seen before.",
      category: "Science",
      tag: "DISCOVERY",
      author: "Elena Kovacs",
      author_initials: "EK",
      published_at: "Apr 23, 2026",
      reading_time: 4,
      featured: false,
      bg: "linear-gradient(135deg, #0c1a2e 0%, #0e2240 50%, #0d3050 100%)"
    },
    %{
      id: 7,
      title: "Historic Peace Agreement Signed After Decade-Long Regional Conflict",
      excerpt:
        "Diplomats from fourteen nations joined the signing ceremony in Brussels, ending a conflict that displaced over three million civilians and reshaped the political map of the region.",
      category: "World",
      tag: "DIPLOMACY",
      author: "Yusuf Hassan",
      author_initials: "YH",
      published_at: "Apr 22, 2026",
      reading_time: 5,
      featured: false,
      bg: "linear-gradient(135deg, #2d1b69 0%, #1a0b4b 50%, #0e0631 100%)"
    },
    %{
      id: 8,
      title: "Cybersecurity Firm Exposes Largest Financial Data Breach in Recorded History",
      excerpt:
        "Over 2.3 billion account records were found exposed on an unprotected server linked to a third-party payment processor used by hundreds of banks worldwide.",
      category: "Technology",
      tag: "SECURITY",
      author: "Nora Lindqvist",
      author_initials: "NL",
      published_at: "Apr 22, 2026",
      reading_time: 8,
      featured: false,
      bg: "linear-gradient(135deg, #1a0000 0%, #3d0000 50%, #5c0000 100%)"
    },
    %{
      id: 9,
      title: "Acclaimed Director's Sci-Fi Epic Breaks Opening Weekend Box Office Records Globally",
      excerpt:
        "The film earned $340 million in its opening weekend, surpassing all previous records and immediately triggering a wave of sequel greenlight announcements from studios.",
      category: "Culture",
      tag: "FILM",
      author: "Isabella Chen",
      author_initials: "IC",
      published_at: "Apr 21, 2026",
      reading_time: 3,
      featured: false,
      bg: "linear-gradient(135deg, #1a0a2e 0%, #2d1b4e 50%, #3d2562 100%)"
    },
    %{
      id: 10,
      title: "Olympic Committee Unveils Controversial New Sports Roster for Los Angeles 2028 Games",
      excerpt:
        "Breakdancing exits while flag football and cricket make their Olympic debut. Athletes and fans are sharply divided on the changes to the world's most-watched sporting event.",
      category: "Sports",
      tag: "OLYMPICS",
      author: "Marcus Thompson",
      author_initials: "MT",
      published_at: "Apr 21, 2026",
      reading_time: 4,
      featured: false,
      bg: "linear-gradient(135deg, #14532d 0%, #166534 50%, #15803d 100%)"
    }
  ]

  def get_featured, do: hd(@articles)

  def get_latest(n \\ 6), do: @articles |> tl() |> Enum.take(n)

  def get_trending(n \\ 5), do: @articles |> Enum.drop(5) |> Enum.take(n)

  def get_by_category(category, n \\ 4) do
    @articles |> Enum.filter(&(&1.category == category)) |> Enum.take(n)
  end

  def get_editor_pick, do: Enum.at(@articles, 4)

  def breaking_headlines do
    [
      "Senate passes landmark infrastructure bill with rare bipartisan support",
      "Tech giant announces layoffs of 12,000 amid sweeping cost-cutting restructure",
      "Hurricane warning issued for Gulf Coast states as Category 4 storm intensifies",
      "New study links ultra-processed food consumption to accelerated cognitive decline",
      "Central bank governor signals rate cuts are possible before year-end",
      "Astronomers detect unusual radio signal originating from nearby star system",
      "General strike paralyses transport networks across three European capitals"
    ]
  end
end