                <%= @issue.key.verbose %> <%= @issue.summary.bold %> <%= @issue.self.data %>
                <%= @issue.status.name.data %> <%= @issue.issuetype.name.data %>
                <% if @issue.attachment.length: %><%= @issue.attachment.length %> attachments<% end %>
                <%= @issue.customfield_10120.displayName.verbose %> <<%= @issue.customfield_10120.emailAddress.verbose %>> (<%= @issue.customfield_10120.name.verbose %>)
                <%= @_relative(new Date(@issue.created)).data %>, <%= @issue.reporter.displayName.data %> <<%= @issue.reporter.emailAddress.grey %>> (<%= @issue.reporter.name.grey %>)
                <%= @_relative(new Date(@issue.updated)) %>, <%= @issue.assignee.displayName %> <<%= @issue.assignee.emailAddress.grey %>> (<%= @issue.assignee.name.grey %>)
<% for issuelink in @issue.issuelinks: %><% if issuelink.inwardIssue: %><% issue2 = issuelink.inwardIssue %>
                <%= issuelink.type.inward %>
                <%= issue2.key.verbose %> <%= issue2.fields.summary.bold %> <%= issue2.self.data %>
                <%= issue2.fields.status.name %> <%= issue2.fields.issuetype.name.data %>
<% end %><% end %>
<% if @issue.subtasks?.length: %>
<%= (@issue.subtasks.length + ' sub-tasks').verbose %><% for subtask in @issue.subtasks: %>
                <%= subtask.key.verbose %> <%= subtask.fields.summary.bold %> <%= subtask.self.data %>
                <%= subtask.fields.status.name %> <%= subtask.fields.issuetype.name.data %>
<% end %><% end %>
<% if @issue.comment.total: %><% for comment in @issue.comment.comments: %>
                <%= @_relative(new Date(comment.updated)) %>, <%= comment.author.displayName %> <<%= comment.author.emailAddress.grey %>> (<%= comment.author.name.grey %>)
<%= comment.body.data %>
<% end %><% end %>
