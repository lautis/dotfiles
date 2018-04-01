def latest_stable_version(versions)
  versions
    .map(&:strip)
    .select { |version| version.match?(/^\d+\.\d+\.\d+$/) }
    .sort_by { |version| Gem::Version.new(version) }
    .last
end
