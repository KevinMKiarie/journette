defmodule JournetteWeb.PageLive.Landing do
  use JournetteWeb, :live_view

  alias Journette.Blog

  @categories ~w[World Politics Business Technology Sports Culture Opinion]

  @impl true
  def mount(_params, _session, socket) do
    headlines = Blog.breaking_headlines()

    {:ok,
     assign(socket,
       page_title: "Journette — Where Great Journalism Lives",
       featured: Blog.get_featured(),
       latest: Blog.get_latest(3),
       editor_pick: Blog.get_editor_pick(),
       trending: Blog.get_trending(5),
       tech_articles: Blog.get_by_category("Technology", 4),
       ticker_headlines: headlines ++ headlines
     )}
  end

  @impl true
  def handle_event("subscribe_newsletter", %{"email" => email}, socket) do
    if String.match?(email, ~r/^[^@\s]+@[^@\s]+$/) do
      {:noreply,
       socket
       |> put_flash(:info, "You're subscribed! Check #{email} for your welcome email.")}
    else
      {:noreply, put_flash(socket, :error, "Please enter a valid email address.")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <Layouts.flash_group flash={@flash} />
      <.breaking_ticker headlines={@ticker_headlines} />
      <.landing_nav current_scope={@current_scope} />
      <main>
        <.hero_section article={@featured} />
        <.latest_section articles={@latest} />
        <.editors_trending editor_pick={@editor_pick} trending={@trending} />
        <.tech_section articles={@tech_articles} />
        <.newsletter_cta />
      </main>
      <.site_footer />
    </div>
    """
  end

  defp breaking_ticker(assigns) do
    ~H"""
    <div class="bg-primary text-primary-content overflow-hidden">
      <div class="flex items-center h-9">
        <div class="shrink-0 bg-black/30 px-4 h-full flex items-center">
          <span class="text-xs font-black uppercase tracking-widest">Breaking</span>
        </div>
        <div class="overflow-hidden flex-1 relative">
          <div class="ticker-animate flex items-center whitespace-nowrap">
            <span :for={headline <- @headlines} class="text-sm px-8 flex items-center gap-8">
              {headline}
              <span class="opacity-40">·</span>
            </span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp landing_nav(assigns) do
    assigns = assign(assigns, :categories, @categories)

    ~H"""
    <nav class="sticky top-0 z-50 bg-base-100/95 backdrop-blur border-b border-base-300">
      <div class="max-w-7xl mx-auto px-4 lg:px-8">
        <div class="flex items-center h-16 gap-4">
          <a href="/" class="shrink-0">
            <img src={~p"/images/Journette.png"} class="h-8 w-auto" alt="Journette" />
          </a>

          <div class="hidden lg:flex items-center gap-0.5 flex-1 justify-center">
            <a
              :for={cat <- @categories}
              href={"##{String.downcase(cat)}"}
              class="px-3 py-1.5 text-sm font-medium text-base-content/65 hover:text-primary rounded-md hover:bg-base-200 transition-colors whitespace-nowrap"
            >
              {cat}
            </a>
          </div>

          <div class="flex items-center gap-2 shrink-0 ml-auto">
            <span class="hidden md:block text-xs text-base-content/40 tabular-nums">
              {Calendar.strftime(Date.utc_today(), "%B %d, %Y")}
            </span>
            <button class="btn btn-ghost btn-sm btn-square" aria-label="Search">
              <.icon name="hero-magnifying-glass" class="size-4" />
            </button>
            <%= if @current_scope && @current_scope.user do %>
              <a href={~p"/users/settings"} class="btn btn-ghost btn-sm">
                <.icon name="hero-user-circle" class="size-4" />
                <span class="hidden sm:block max-w-32 truncate text-xs">
                  {@current_scope.user.email}
                </span>
              </a>
            <% else %>
              <a href={~p"/users/log-in"} class="btn btn-ghost btn-sm hidden sm:inline-flex">
                Sign in
              </a>
              <a href={~p"/users/register"} class="btn btn-primary btn-sm">
                Subscribe
              </a>
            <% end %>
          </div>
        </div>
      </div>

      <%!-- Mobile category scroll --%>
      <div class="lg:hidden border-t border-base-200 overflow-x-auto scrollbar-hide">
        <div class="flex items-center gap-0.5 px-4 py-1 w-max">
          <a
            :for={cat <- @categories}
            href={"##{String.downcase(cat)}"}
            class="px-3 py-1 text-xs font-medium text-base-content/60 hover:text-primary whitespace-nowrap"
          >
            {cat}
          </a>
        </div>
      </div>
    </nav>
    """
  end

  defp hero_section(assigns) do
    ~H"""
    <section class="max-w-7xl mx-auto px-4 lg:px-8 py-8">
      <div class="relative  overflow-hidden h-[520px] cursor-pointer group">
        <div class="absolute inset-0" style={"background: #{@article.bg}"}></div>
        <div class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/30 to-transparent">
        </div>

        <div class="relative h-full flex flex-col justify-end p-8 lg:p-12">
          <div class="flex items-center gap-3 mb-4">
            <span class="badge badge-primary text-xs font-black uppercase tracking-wider px-3 py-1">
              {@article.category}
            </span>
            <span class="text-white/50 text-sm">{@article.published_at}</span>
            <span class="text-white/50 text-sm hidden sm:block">
              · {@article.reading_time} min read
            </span>
          </div>

          <h1 class="text-3xl lg:text-5xl font-black text-white leading-tight mb-4 max-w-3xl group-hover:text-primary transition-colors duration-300">
            {@article.title}
          </h1>
          <p class="text-white/65 text-lg mb-6 max-w-2xl hidden md:block leading-relaxed">
            {@article.excerpt}
          </p>

          <div class="flex items-center gap-4">
            <div class="flex items-center gap-2">
              <div class="size-8  bg-primary flex items-center justify-center text-primary-content text-xs font-bold shrink-0">
                {@article.author_initials}
              </div>
              <span class="text-white text-sm font-medium">{@article.author}</span>
            </div>
            <a href="#" class="ml-auto btn btn-primary btn-sm">
              Read Story <span aria-hidden="true">→</span>
            </a>
          </div>
        </div>
      </div>
    </section>
    """
  end

  defp latest_section(assigns) do
    ~H"""
    <section class="max-w-7xl mx-auto px-4 lg:px-8 pb-12">
      <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-black text-base-content uppercase tracking-wider">
          Latest Stories
        </h2>
        <a href="#" class="text-sm font-medium text-primary hover:underline">
          See all →
        </a>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <.article_card :for={article <- @articles} article={article} />
      </div>
    </section>
    """
  end

  defp article_card(assigns) do
    ~H"""
    <article class="group cursor-pointer">
      <div class="relative  overflow-hidden h-52 mb-4">
        <div
          class="absolute inset-0 transition-transform duration-500 group-hover:scale-105"
          style={"background: #{@article.bg}"}
        >
        </div>
        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
        <div class="absolute bottom-3 left-3">
          <span class="badge badge-primary text-xs font-bold uppercase">
            {@article.category}
          </span>
        </div>
      </div>
      <div>
        <h3 class="font-bold text-base-content text-base leading-snug mb-2 line-clamp-2 group-hover:text-primary transition-colors">
          {@article.title}
        </h3>
        <div class="flex items-center gap-2 text-xs text-base-content/50">
          <div class="size-5  bg-base-300 flex items-center justify-center text-base-content/70 font-bold text-[10px] shrink-0">
            {@article.author_initials}
          </div>
          <span>{@article.author}</span>
          <span>·</span>
          <span>{@article.published_at}</span>
          <span>·</span>
          <span>{@article.reading_time}m</span>
        </div>
      </div>
    </article>
    """
  end

  defp editors_trending(assigns) do
    ~H"""
    <section class="max-w-7xl mx-auto px-4 lg:px-8 pb-14">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <%!-- Editor's Pick --%>
        <div class="lg:col-span-2">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-black text-base-content uppercase tracking-wider">
              Editor's Pick
            </h2>
          </div>
          <article class="group cursor-pointer">
            <div class="relative  overflow-hidden h-80 mb-5">
              <div
                class="absolute inset-0 transition-transform duration-500 group-hover:scale-105"
                style={"background: #{@editor_pick.bg}"}
              >
              </div>
              <div class="absolute inset-0 bg-gradient-to-t from-black/85 via-black/20 to-transparent">
              </div>
              <div class="absolute bottom-0 left-0 right-0 p-6">
                <span class="badge badge-primary text-xs font-black uppercase mb-3 block w-fit">
                  {@editor_pick.tag}
                </span>
                <h3 class="text-2xl font-black text-white leading-tight group-hover:text-primary/90 transition-colors">
                  {@editor_pick.title}
                </h3>
              </div>
            </div>
            <p class="text-base-content/65 text-sm leading-relaxed mb-3 line-clamp-2">
              {@editor_pick.excerpt}
            </p>
            <div class="flex items-center gap-2 text-xs text-base-content/50">
              <div class="size-6  bg-primary flex items-center justify-center text-primary-content font-bold text-[10px]">
                {@editor_pick.author_initials}
              </div>
              <span class="font-medium text-base-content/70">{@editor_pick.author}</span>
              <span>·</span>
              <span>{@editor_pick.published_at}</span>
              <span>·</span>
              <span>{@editor_pick.reading_time} min read</span>
            </div>
          </article>
        </div>

        <%!-- Trending Now --%>
        <div>
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-black text-base-content uppercase tracking-wider">
              Trending Now
            </h2>
          </div>
          <ol class="space-y-5">
            <li
              :for={{article, i} <- Enum.with_index(@trending, 1)}
              class="group flex gap-4 cursor-pointer"
            >
              <span class="text-4xl font-black text-base-content/10 leading-none tabular-nums shrink-0 w-8 text-right">
                {i}
              </span>
              <div>
                <span class="text-[10px] font-black uppercase tracking-wider text-primary mb-1 block">
                  {article.category}
                </span>
                <h4 class="text-sm font-bold text-base-content leading-snug line-clamp-2 group-hover:text-primary transition-colors">
                  {article.title}
                </h4>
                <p class="text-xs text-base-content/45 mt-1">{article.published_at}</p>
              </div>
            </li>
          </ol>
        </div>
      </div>
    </section>
    """
  end

  defp tech_section(assigns) do
    ~H"""
    <section id="technology" class="max-w-7xl mx-auto px-4 lg:px-8 pb-14">
      <div class="flex items-center gap-4 mb-6">
        <div class="h-px flex-1 bg-base-300"></div>
        <div class="flex items-center gap-4 shrink-0">
          <h2 class="text-xl font-black text-base-content uppercase tracking-wider">Technology</h2>
          <a href="#" class="text-sm font-medium text-primary hover:underline">See All →</a>
        </div>
        <div class="h-px flex-1 bg-base-300"></div>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <.article_card :for={article <- @articles} article={article} />
      </div>
    </section>
    """
  end

  defp newsletter_cta(assigns) do
    ~H"""
    <section class="bg-neutral text-neutral-content py-20 px-4">
      <div class="max-w-2xl mx-auto text-center">
        <div class="inline-flex size-12 items-center justify-center  bg-primary/20 mb-6">
          <.icon name="hero-envelope-open" class="size-6 text-primary" />
        </div>
        <h2 class="text-4xl font-black mb-3">Never Miss a Story</h2>
        <p class="text-neutral-content/60 text-lg mb-8">
          Get the most important stories delivered to your inbox every morning, curated by our editors.
        </p>

        <form
          phx-submit="subscribe_newsletter"
          class="flex flex-col sm:flex-row gap-3 max-w-md mx-auto"
        >
          <input
            type="email"
            name="email"
            placeholder="your@email.com"
            required
            class="input input-bordered flex-1 bg-neutral-content/10 border-neutral-content/20 text-neutral-content placeholder:text-neutral-content/40 focus:border-primary"
          />
          <button type="submit" class="btn btn-primary shrink-0">
            Subscribe Free
          </button>
        </form>
        <p class="text-neutral-content/35 text-xs mt-4">
          No spam. Unsubscribe at any time.
        </p>
      </div>
    </section>
    """
  end

  defp site_footer(assigns) do
    ~H"""
    <footer class="bg-base-200 border-t border-base-300">
      <div class="max-w-7xl mx-auto px-4 lg:px-8 py-16">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-10">
          <%!-- Brand --%>
          <div class="md:col-span-1">
            <img src={~p"/images/Journette.png"} class="h-8 w-auto mb-4" alt="Journette" />
            <p class="text-base-content/55 text-sm leading-relaxed">
              Independent journalism for a better-informed world. Trusted by readers in 190+ countries.
            </p>
            <div class="flex gap-3 mt-6">
              <a href="#" class="btn btn-ghost btn-sm btn-square" aria-label="Twitter/X">
                <svg class="size-4" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-4.714-6.231-5.401 6.231H2.742l7.732-8.853L1.5 2.25h6.944l4.26 5.631 5.54-5.631zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                </svg>
              </a>
              <a href="#" class="btn btn-ghost btn-sm btn-square" aria-label="LinkedIn">
                <svg class="size-4" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
                </svg>
              </a>
              <a href="#" class="btn btn-ghost btn-sm btn-square" aria-label="RSS">
                <.icon name="hero-rss" class="size-4" />
              </a>
            </div>
          </div>

          <%!-- Categories --%>
          <div>
            <h4 class="font-black text-sm uppercase tracking-wider text-base-content mb-4">
              Categories
            </h4>
            <ul class="space-y-2">
              <li :for={cat <- ~w[World Politics Business Technology Sports Culture Opinion Science]}>
                <a
                  href={"##{String.downcase(cat)}"}
                  class="text-sm text-base-content/60 hover:text-primary transition-colors"
                >
                  {cat}
                </a>
              </li>
            </ul>
          </div>

          <%!-- Company --%>
          <div>
            <h4 class="font-black text-sm uppercase tracking-wider text-base-content mb-4">
              Company
            </h4>
            <ul class="space-y-2">
              <li :for={link <- ~w[About\ Us Our\ Team Careers Advertise Press\ Kit Contact]}>
                <a href="#" class="text-sm text-base-content/60 hover:text-primary transition-colors">
                  {link}
                </a>
              </li>
            </ul>
          </div>

          <%!-- Account --%>
          <div>
            <h4 class="font-black text-sm uppercase tracking-wider text-base-content mb-4">
              Readers
            </h4>
            <ul class="space-y-2">
              <li>
                <a
                  href={~p"/users/register"}
                  class="text-sm text-base-content/60 hover:text-primary transition-colors"
                >
                  Create Account
                </a>
              </li>
              <li>
                <a
                  href={~p"/users/log-in"}
                  class="text-sm text-base-content/60 hover:text-primary transition-colors"
                >
                  Sign In
                </a>
              </li>
              <li>
                <a href="#" class="text-sm text-base-content/60 hover:text-primary transition-colors">
                  Newsletter
                </a>
              </li>
              <li>
                <a href="#" class="text-sm text-base-content/60 hover:text-primary transition-colors">
                  RSS Feed
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <div class="border-t border-base-300">
        <div class="max-w-7xl mx-auto px-4 lg:px-8 py-5 flex flex-col sm:flex-row items-center justify-between gap-3">
          <p class="text-xs text-base-content/40">
            © 2026 Journette. All rights reserved.
          </p>
          <div class="flex gap-5">
            <a href="#" class="text-xs text-base-content/40 hover:text-base-content/70">
              Privacy Policy
            </a>
            <a href="#" class="text-xs text-base-content/40 hover:text-base-content/70">
              Terms of Service
            </a>
            <a href="#" class="text-xs text-base-content/40 hover:text-base-content/70">
              Cookie Policy
            </a>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
