{ ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      provider = {
        deepseekv4 = {
          npm = "@ai-sdk/anthropic";
          name = "DeepSeek";
          options = {
            baseURL = "https://api.deepseek.com/anthropic";
          };
        };
      };
    };
  };
}
